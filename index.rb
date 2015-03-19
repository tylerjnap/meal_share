require 'sinatra'
require 'httmultiparty'
require 'debugger' if Sinatra::Base.development?
require 'open-uri'
require 'mini_magick'
require 'twilio-ruby'
require 'dotenv'
require "aws/s3"
require 'active_record'
require 'sinatra/activerecord'
# require './environments'
require 'bcrypt'
require 'htmlentities'

#text flow files
require './text_flow/1_receive_receipt_and_send_breakdown.rb'
require './text_flow/2_correct_breakdown.rb'
require './text_flow/3_add_eaters.rb'
require './text_flow/4_who_ate_what.rb'

set :port, 8086
Dotenv.load

require './variables.rb'

class MealShare < Sinatra::Base
   register Sinatra::ActiveRecordExtension
end

class Meal < ActiveRecord::Base
   has_many :eaters, dependent: :destroy
   has_many :dishes, dependent: :destroy
end

class Eater < ActiveRecord::Base
   has_many :dishes, dependent: :destroy
   belongs_to :meal
end

class Dish < ActiveRecord::Base
   belongs_to :eaters
   belongs_to :meal
end

#Initiate Twilio Client
$client = Twilio::REST::Client.new ENV['account_sid'], ENV['auth_token']

get "/" do
   erb :index
end

post "/signup" do
   $client.messages.create(from: $app_phone_number, to: params[:phone_number], body: $signup_string, media_url: $test_image_url)
   redirect to("/")
end

post "/text_processor" do
   # params = JSON.parse(request.body.read) #if using curl
   puts "Text received from #{params['From']}"
   meal = Meal.find_by_phone_number(params['From'])
   ##1##
   if meal.nil?
      #Meal hasn't been created yet.  Create one, analyze the text, and send back the breakdown to person with instructions on how correct the breakdown
      received_receipt_and_send_breakdown(params)
   elsif !meal.nil? && params["Body"].downcase == "redo"
      ##meal exists and want to redo it
      meal.destroy
   else
   ##/1##
      #Meal has already been created
      ##2##
      if meal.sent_breakdown == true && meal.confirmed_breakdown.nil? && meal.received_names_of_eaters.nil?
         #Correct the breakdown
         if params["Body"].downcase == "ok"
            #update database so next text will execute next text_flow
            meal.update_attributes(confirmed_breakdown: true)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: $send_eaters_string) #send confirmation text and next steps for confirming people person is eating with
         else
            #implement corrections. Always go to this one until 'ok' is sent
            correct_breakdown(params["Body"], meal)
            new_breakdown = format_bill(meal)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: new_breakdown)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: $finished_corrections)
         end
      ##/2##
      ##3##
      elsif  meal.sent_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters.nil?         #Add people the person dined with (Eaters)
         if params["Body"].downcase == "ok"
            #update database so next text will execute next text_flow
            meal.update_attributes(received_names_of_eaters: true)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: $send_eaters_breakdown_string) #send confirmation text and next steps for telling who ate what
         else
            #add eaters
            add_eaters(params["Body"], meal)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: "If that's everyone, text 'OK', to us.")
         end
      ##/3#
      ##4##
      elsif  meal.sent_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters == true
         #Add which people had which meals
         if params["Body"].downcase == "ok"
            #update database so next text will execute next text_flow
            message_payload = calculate_what_everyone_owes(meal)
            string = format_string_who_owes_what_breakdown(message_payload)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: string) #send confirmation text and next steps for confirming people person is eating with
            meal.destroy #delete meal instance from the database
         else
            #add who ate what meal
            who_ate_what(params["Body"], meal)
            $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: "If that's what' everyone is having, text 'OK' to us.")
         end
      ##/4##
      end
   end
end

def format_bill meal
   string = "Here is the updated bill:\n\n"
   dishes = meal.dishes
   dishes.each do |dish|
      string << "\n#{dish.bin_key} : #{dish.item} : $#{dish.price}"
   end
   return string
end
