class CreateDishes < ActiveRecord::Migration
  def change
     create_table :dishes do |t|
        t.integer :meal_id
        t.integer :eater_id
        t.string :item
        t.string :price
        t.string :bin_key
     end
  end
end
