class CreateMeals < ActiveRecord::Migration
  def change
     create_table :meals do |t|
        t.string :phone_number

        t.boolean :sent_breakdown
        t.boolean :confirmed_breakdown
        t.boolean :received_names_of_eaters
     end
  end
end
