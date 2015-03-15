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

require './text_flow/receive_receipt_and_send_breakdown.rb'

set :port, 8085
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

post "/" do
   params = JSON.parse(request.body.read) #if using curl
   puts "Text received from #{params['From']}"
   meal = Meal.find_by_phone_number(params['From'])
   if meal.nil?
      received_receipt_and_send_breakdown(params)
   else
      if meal.sent_breakdown == true && meal.corrected_breakdown.nil? && meal.confirmed_breakdown.nil? && meal.received_names_of_eaters.nil? && meal.received_all_eaters_dishes.nil? && meal.confirmed_all_dishes.nil? && meal.sent_total.nil?
         if params["Body"].downcase != "ok"
            #implement corrections
            correct_breakdown(params["Body"], meal)
         else
            #update database so next text will execute next text_flow
            meal.update_attributes(confirmed_breakdown: true)
         end
      # elsif  meal.sent_breakdown == true && meal.corrected_breakdown == true && meal.confirmed_breakdown.nil? && meal.received_names_of_eaters.nil? && meal.received_all_eaters_dishes.nil? && meal.confirmed_all_dishes.nil? && meal.sent_total.nil?
      #
      # elsif  meal.sent_breakdown == true && meal.corrected_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters.nil? && meal.received_all_eaters_dishes.nil? && meal.confirmed_all_dishes.nil? && meal.sent_total.nil?
      #
      # elsif  meal.sent_breakdown == true && meal.corrected_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters == true && meal.received_all_eaters_dishes.nil? && meal.confirmed_all_dishes.nil? && meal.sent_total.nil?
      #
      # elsif  meal.sent_breakdown == true && meal.corrected_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters == true && meal.received_all_eaters_dishes == true && meal.confirmed_all_dishes.nil? && meal.sent_total.nil?
      #
      # elsif  meal.sent_breakdown == true && meal.corrected_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters == true && meal.received_all_eaters_dishes == true && meal.confirmed_all_dishes == true && meal.sent_total.nil?
      #
      # elsif  meal.sent_breakdown == true && meal.corrected_breakdown == true && meal.confirmed_breakdown == true && meal.received_names_of_eaters == true && meal.received_all_eaters_dishes == true && meal.confirmed_all_dishes == true && meal.sent_total == true

      end
   end
end

#key functions
def format_items_for_text (meal)
   string = ""
   dishes = meal.dishes
   dishes.each do |dish|
      string << "\n#{dish.bin_key} : #{dish.item} : $#{dish.price}"
   end
   return string
end

string = "Lnluss\n. @\n\"ixi'i;i&5 V NG\nLONE'S HONE CENTERS LLC\nzoo n1seLE£ uR1vÉ\nGARDEN CITY, NY 11530 (516) ?94-653I\n* SALE -\nSNLESN: FSILANEI 13 TRANSN: 5204425 11-28-14\nI58890 IsA I25V NHITE GFCI I2 58\n104033 IsA I20V WHITE sF DECO 5N 4:96\n2 O 2.48\nX\n802?I 2-GANG WALL PLATE TF262NC 1 58\n1*\n356351 7 DAY BASIC PROGRANHABLE 34:98\n49.99 DISCOUNT EACH -I5.OI\n344556 FS 2-LIGHT BN FALLSBROOK I5.97\n17.97 DISCOUNT EACH -2.00\n28630 BATH DRAIN 2OGA TRIFLEVER 58.99\nSUBTOTAL: I29.06\nINN: I1.13\nW TOTNL: NBAS\nVISA: NBAS\nI; *,:1 .\"NT; 1Ll7..()\"1.\n;;;NHOUNT:I4O.19 NUTNCD:DO79BB\né;CIL•!•.,. ; is 11/28/ IN ,14 ;53159\nAM f ' ! *\n;\"T, €; 11/28714 14:54:06\nPURCHASED: 7\nIN S AND SPECIAL ORDER ITEMS\nIT INTINlNNI\n1"
