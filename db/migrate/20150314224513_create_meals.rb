class CreateMeals < ActiveRecord::Migration
  def change
     create_table :meals do |t|
        t.string :phone_number

        t.boolean :sent_breakdown
        t.boolean :corrected_breakdown
        t.boolean :confirmed_breakdown
        t.boolean :received_names_of_eaters
        t.boolean :received_all_eaters_dishes
        t.boolean :confirmed_all_dishes
        t.boolean :sent_total        
     end
  end
end
