def add_eaters(body, meal)
   body.split("\n").each do |line|
      meal.eaters.create!({name: line})
   end
end
