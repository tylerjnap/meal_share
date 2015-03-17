def who_ate_what(body, meal)
   body.split("\n").each do |line|
      vals = line.split(":")
      eater = meal.eaters.find_by_name(vals.first)
      vals.last.split(",").each do |bin_key|
         dish = meal.dishes.find_by_bin_key(bin_key)
         dish.update_attributes(eater_id: eater.id)
      end
   end
end

def calculate_what_everyone_owes(meal)
   message_payload = []
   eaters = meal.eaters
   eaters.each do |eater|
      before_t_a_t = 0
      eater.dishes.each do |dish|
         before_t_a_t += dish.price.to_f
      end
      tax = (before_t_a_t*0.085).round(2)
      tip = ((before_t_a_t+tax)*0.20).round(2)
      total = before_t_a_t + tax + tip
      message_payload << {name: "#{eater.name}", before_t_a_t: before_t_a_t.to_s, tax: tax.to_s , tip: tip.to_s, total: total.to_s}
   end
   return message_payload #returns an array of hashses
end

def format_string_who_owes_what_breakdown(message_payload)
   string = ""
   message_payload.each do |person|
      string << "\n\n#{person[:name]}\n--------------\nBefore Tax and Tip: #{person[:before_t_a_t]}\nTax: #{person[:tax]}\nTip: #{person[:tip]}\nTotal: #{person[:total]}"
   end
   return string
end
