class CreateMeals < ActiveRecord::Migration
  def change
     create_table :meals do |t|
        t.string :phone_number
     end
  end
end
