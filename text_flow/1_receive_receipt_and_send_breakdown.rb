def received_receipt_and_send_breakdown params
   response = HTTParty.get("https://api.idolondemand.com/1/api/sync/ocrdocument/v1?url=#{URI.encode(params["MediaUrl0"])}&apikey=81b77cb6-88ce-42ec-bea0-eca4c98405c6")
   string = HTMLEntities.new.decode(response.parsed_response["text_block"].first["text"])
   items = analyze_receipt_text(string)
   meal = save_initial_meal_instance(params['From'], items)
   items_string = format_items_for_text(meal)
   $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: items_string) ## send items
   $client.messages.create(from: $app_phone_number, to: meal.phone_number, body: $correct_breakdown_string)
end

def save_initial_meal_instance phone_number, items
   meal = Meal.create({phone_number: phone_number, sent_breakdown: true})
   items.each do |item|
      meal.dishes.create!({bin_key: item[:bin_key], item: item[:item], price: item[:price]})
   end
   return meal
end

def analyze_receipt_text(string)
   all_items_and_prices = []
   letters_index = 0
   string.split("\n").each do |line|
      last_digit = line.split("").last
      if $numbers.include?(last_digit) #execute only if last digit is a number, ? (aka 7), or I (aka 1)
         item_and_price = Hash.new
         price_array = []
         chars = line.split("")
         index = chars.length-1 #accounting for zero indexing
         decimal_yet = false
         number_counter = 0
         decimal_counter = 0
         while $numbers.include?(chars[index]) || $decimals.include?(chars[index]) #analyze each digit, from last to beginning so long as it is a number, ? (aka 7), or I (aka 1)
            if $decimals.include?(chars[index])
               if decimal_yet == false
                  decimal_yet = true
                  decimal_counter += 1
                  chars[index] = "." if chars[index] == ":" || chars[index] == " "
               elsif decimal_yet == true
                  break
               end
            elsif $numbers.include?(chars[index])
               number_counter +=1
            end
            ##change ? and I to 7 and 1, respectively
            chars[index] = "7" if chars[index] == "?"
            chars[index] = "1" if chars[index] == "I"
            price_array << chars[index]
            index -= 1
         end
         ##weed out prices that woudln't make sense by number of digits and number of decimal points
         if number_counter >= 3 && decimal_counter != 0 #maybe make 2 for .99 instead of 0.99
            price = price_array.reverse.join #create price
            item = line[0...index] #create item
            item_and_price = {bin_key: $letters[letters_index], item: item, price: price} #create hash of item and price
            letters_index += 1 #increment next bin_key
            all_items_and_prices << item_and_price #add this hash to array of all items and prices
         end
         ##
      end
   end
   return all_items_and_prices
end

def format_items_for_text (meal)
   string = "Thanks for using our service.  Here is the breakdown for who owes what:\n\n"
   dishes = meal.dishes
   dishes.each do |dish|
      string << "\n#{dish.bin_key} : #{dish.item} : $#{dish.price}"
   end
   return string
end
