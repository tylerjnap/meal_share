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
$numbers = ["0","1","2","3","4","5","6","7","8","9", "I", "?"]
$decimals = [".", ":", " "]

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
   all_items_and_prices = []
   string.split("\n").each do |line|
      last_digit = line.split("").last
      if $numbers.include?(last_digit) #execute only if last digit is a number, ? (aka 7), or I (aka 1)
         item_and_price = Hash.new
         price_array = []
         chars = line.split("")
         index = chars.length-1 #accounting for zero indexing
         while $numbers.include?(chars[index]) || $decimals.include?(chars[index]) #analyze each digit, from last to beginning so long as it is a number, ? (aka 7), or I (aka 1)
            chars[index] = "." if chars[index] ==":" || chars[index] == " "
            price_array << chars[index]
            index -= 1
         end
         ##
         #stuff I took out
         ##
         price = price_array.reverse.join #create price
         item = line[0...index] #create item
         item_and_price = {item: item, price: price} #create hash of item and price
         all_items_and_prices << item_and_price #add this hash to array of all items and prices
      end
   end
   return all_items_and_prices
end

string = "Lnluss\n. @\n\"ixi'i;i&5 V NG\nLONE'S HONE CENTERS LLC\nzoo n1seLE£ uR1vÉ\nGARDEN CITY, NY 11530 (516) ?94-653I\n* SALE -\nSNLESN: FSILANEI 13 TRANSN: 5204425 11-28-14\nI58890 IsA I25V NHITE GFCI I2 58\n104033 IsA I20V WHITE sF DECO 5N 4:96\n2 O 2.48\nX\n802?I 2-GANG WALL PLATE TF262NC 1 58\n1*\n356351 7 DAY BASIC PROGRANHABLE 34:98\n49.99 DISCOUNT EACH -I5.OI\n344556 FS 2-LIGHT BN FALLSBROOK I5.97\n17.97 DISCOUNT EACH -2.00\n28630 BATH DRAIN 2OGA TRIFLEVER 58.99\nSUBTOTAL: I29.06\nINN: I1.13\nW TOTNL: NBAS\nVISA: NBAS\nI; *,:1 .\"NT; 1Ll7..()\"1.\n;;;NHOUNT:I4O.19 NUTNCD:DO79BB\né;CIL•!•.,. ; is 11/28/ IN ,14 ;53159\nAM f ' ! *\n;\"T, €; 11/28714 14:54:06\nPURCHASED: 7\nIN S AND SPECIAL ORDER ITEMS\nIT INTINlNNI\n1"

# ##format price (still reversed at this point)
# false_decimal_place = price_array.length-1
# decimal_yet = false
# for i in (0...price_array.length)
#    if price_array[i] =="."
#       if decimal_yet == false
#          decimal_yet = true
#       else
#          false_decimal_place = i
#       end
#    elsif price_array[i] == "?"
#       price_array[i] = "7"
#    elsif price_array[i] = "I"
#       price_array[i] = "1"
#    end
# end
# price_array_new = price_array[0...decimal_place]
# ##
# # ##
# # #take out "." at end of
# # last_char = price_array.last
# # price_array.delete_at(price_array.length-1) if last_char == "."
# # ##

# def analyze_receipt_text(string)
#    items = []
#    string.split("\n").each do |line|
#       last_digit = line.split("").last
#       items << line if $numbers.include?(last_digit.to_i) || last_digit == "?" || last_digit == "I"
#    end
#    return items
# end
