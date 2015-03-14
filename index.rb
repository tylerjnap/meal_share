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

set :port, 8085
Dotenv.load
$numbers = [0,1,2,3,4,5,6,7,8,9]

#Initiate Twilio Client
client = Twilio::REST::Client.new ENV['account_sid'], ENV['auth_token']

post "/" do
   puts "Text received from #{params['From']}"
   response = HTTParty.get("https://api.idolondemand.com/1/api/sync/ocrdocument/v1?url=#{URI.encode(params["MediaUrl0"])}&apikey=81b77cb6-88ce-42ec-bea0-eca4c98405c6")
   string = HTMLEntities.new.decode(response.parsed_response["text_block"].first["text"])
   items = analyze_receipt_text(string)
   debugger
   debugger
end

def analyze_receipt_text(string)
   items = []
   string.split("\n").each do |line|
      last_digit = line.split("").last
      items << line if $numbers.include?(last_digit.to_i) || last_digit == "?" || last_digit == "I"
   end
   return items
end
