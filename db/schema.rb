# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_07_28_105956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendences", force: :cascade do |t|
    t.integer "working_hours"
    t.integer "leaves"
    t.boolean "attended"
    t.date "date", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "date"], name: "index_attendences_on_employee_id_and_date", unique: true
    t.index ["employee_id"], name: "index_attendences_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_employees_on_admin_id"
  end

  add_foreign_key "attendences", "employees"
  add_foreign_key "employees", "admins"
end
