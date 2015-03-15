class CreateEaters < ActiveRecord::Migration
  def change
     create_table :eaters do |t|
        t.string :name
        t.integer :meal_id
        t.boolean :confirmed_meal
     end
  end
end
