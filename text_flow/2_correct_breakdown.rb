def correct_breakdown(body, meal)
   body.split("\n").each do |line|
      vals = line.split(":")
      dish = meal.dishes.find_by_bin_key(vals.first.downcase)
      if dish.nil?
         #add new item
         meal.dishes.create!({bin_key: meal.dishes.last.bin_key.next, item: vals[0], price: vals[1]})
      else
         #correct item
         if vals.length == 3
            #correct everything
            dish.update_attributes(item: vals[1], price: vals[2])
         else
            #correct only name or price, or delete item
            if vals.last == "delete"
               #delete dish
               dish.destroy
            else
               #correct only name or price
               if $letters.include?(vals.last.split("").first.downcase) #check first character of second (last) entry
                  #correct the name
                  dish.update_attributes(item: vals.last)
               else
                  #correct the price
                  dish.update_attributes(price: vals.last)
               end
            end
         end
      end
   end
end
