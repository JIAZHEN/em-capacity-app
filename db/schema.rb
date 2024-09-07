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

ActiveRecord::Schema[7.1].define(version: 2024_09_07_084218) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "calendar_date"
    t.boolean "half_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "absence_type", default: 0
    t.index ["employee_id"], name: "index_absences_on_employee_id"
  end

  create_table "bank_holidays", force: :cascade do |t|
    t.date "calendar_date"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_allowances", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.integer "year"
    t.integer "holiday_allowance"
    t.integer "sick_leave_allowance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_allowances_on_employee_id"
  end

  create_table "employee_factors", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.float "factor"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_factors_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team", default: "Engineering"
    t.index ["team"], name: "index_employees_on_team"
  end

  add_foreign_key "absences", "employees"
  add_foreign_key "employee_allowances", "employees"
  add_foreign_key "employee_factors", "employees"
end
