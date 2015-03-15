def save_initial_meal_instance phone_number, items
   meal = Meal.create({phone_number: phone_number, sent_breakdown: true})
   items.each do |item|
      meal.dishes.create!({bin_key: item[:bin_key], item: item[:item], price: item[:price]})
   end
   return meal
end

def analyze_receipt_text(string)
   debugger
   debugger
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
         puts "#{number_counter}: #{decimal_counter}"
         ##weed out prices that woudln't make sense by number of digits and number of decimal points
         if number_counter >= 3 && decimal_counter != 0 #maybe make 2 for .99 instead of 0.99
            price = price_array.reverse.join #create price
            item = line[0...index] #create item
            # debugger
            item_and_price = {bin_key: $letters[letters_index], item: item, price: price} #create hash of item and price
            letters_index += 1 #increment next bin_key
            # debugger
            all_items_and_prices << item_and_price #add this hash to array of all items and prices
         end
         ##
      end
   end
   return all_items_and_prices
end
