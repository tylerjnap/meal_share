# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150314224951) do

  create_table "dishes", force: :cascade do |t|
    t.integer "meal_id"
    t.integer "eater_id"
    t.string  "item"
    t.string  "price"
    t.string  "bin_key"
  end

  create_table "eaters", force: :cascade do |t|
    t.string  "name"
    t.integer "meal_id"
    t.boolean "confirmed_meal"
  end

  create_table "meals", force: :cascade do |t|
    t.string  "phone_number"
    t.boolean "sent_breakdown"
    t.boolean "corrected_breakdown"
    t.boolean "confirmed_breakdown"
    t.boolean "received_names_of_eaters"
    t.boolean "received_all_eaters_dishes"
    t.boolean "confirmed_all_dishes"
    t.boolean "sent_total"
  end

end
