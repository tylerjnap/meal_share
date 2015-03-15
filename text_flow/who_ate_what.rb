def who_ate_what(body, meal)
   body.split("\n").each do |line|
      vals = line.split(":")
      eater = meal.eaters.find_by_name(vals.first)
      vals.last.split(",").each do |bin_key|
         dish = meal.dishes.find_by_bin_key(bin_key)
         puts eater.id
         dish.update_attributes(eater_id: eater.id)
      end
   end
end
