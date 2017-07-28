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

ActiveRecord::Schema.define(version: 20170721182659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint "task_list_id"
    t.string "value", null: false
    t.boolean "done", default: false
    t.index ["task_list_id"], name: "index_items_on_task_list_id"
  end

  create_table "task_lists", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.index ["user_id"], name: "index_task_lists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name"
  end

  add_foreign_key "items", "task_lists"
  add_foreign_key "task_lists", "users"
end
