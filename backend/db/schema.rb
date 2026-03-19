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

ActiveRecord::Schema[8.1].define(version: 2026_03_19_025310) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.bigint "job_id", null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["job_id"], name: "index_assignments_on_job_id"
    t.index ["job_id"], name: "index_one_active_assignment_per_job", unique: true, where: "(end_date IS NULL)"
    t.index ["user_id"], name: "index_assignments_on_user_id"
    t.index ["user_id"], name: "index_one_active_assignment_per_user", unique: true, where: "(end_date IS NULL)"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "contract_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.date "end_date"
    t.decimal "fte", precision: 4, scale: 2
    t.bigint "position_id", null: false
    t.decimal "rate", precision: 10, scale: 2, null: false
    t.date "start_date", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["position_id"], name: "index_contracts_on_position_id"
    t.index ["user_id"], name: "index_contracts_on_user_id"
    t.index ["user_id"], name: "index_one_active_contract_per_user", unique: true, where: "(end_date IS NULL)"
  end

  create_table "departments", force: :cascade do |t|
    t.boolean "billable"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.decimal "day_rate", precision: 10, scale: 2, null: false
    t.date "end_date"
    t.date "start_date", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_jobs_on_client_id"
  end

  create_table "positions", force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.decimal "max_salary", precision: 10, scale: 2
    t.decimal "min_salary", precision: 10, scale: 2
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_positions_on_department_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "first_name"
    t.integer "gender", default: 3, null: false
    t.string "last_name"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assignments", "jobs", on_delete: :restrict
  add_foreign_key "assignments", "users", on_delete: :restrict
  add_foreign_key "contracts", "positions", on_delete: :restrict
  add_foreign_key "contracts", "users"
  add_foreign_key "jobs", "clients", on_delete: :restrict
  add_foreign_key "positions", "departments", on_delete: :restrict
  add_foreign_key "profiles", "users"
end
