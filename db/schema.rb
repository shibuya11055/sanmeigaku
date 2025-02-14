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

ActiveRecord::Schema[8.0].define(version: 2025_02_12_162037) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "earthly_branches", force: :cascade do |t|
    t.string "name", null: false
    t.integer "yin_yang", null: false
    t.text "description"
    t.bigint "element_id", null: false
    t.bigint "first_stem_id"
    t.integer "first_stem_period_day"
    t.bigint "second_stem_id"
    t.integer "second_stem_period_day"
    t.bigint "third_stem_id"
    t.integer "third_stem_period_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_earthly_branches_on_element_id"
    t.index ["first_stem_id"], name: "index_earthly_branches_on_first_stem_id"
    t.index ["second_stem_id"], name: "index_earthly_branches_on_second_stem_id"
    t.index ["third_stem_id"], name: "index_earthly_branches_on_third_stem_id"
  end

  create_table "elements", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fortune_analyses", force: :cascade do |t|
    t.date "birthday"
    t.bigint "sexagenary_cycle_year_id", null: false
    t.bigint "sexagenary_cycle_month_id", null: false
    t.bigint "sexagenary_cycle_day_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sexagenary_cycle_day_id"], name: "index_fortune_analyses_on_sexagenary_cycle_day_id"
    t.index ["sexagenary_cycle_month_id"], name: "index_fortune_analyses_on_sexagenary_cycle_month_id"
    t.index ["sexagenary_cycle_year_id"], name: "index_fortune_analyses_on_sexagenary_cycle_year_id"
  end

  create_table "heavenly_stems", force: :cascade do |t|
    t.string "name", null: false
    t.integer "yin_yang", null: false
    t.text "description"
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_heavenly_stems_on_element_id"
  end

  create_table "sexagenary_cycles", force: :cascade do |t|
    t.integer "number", null: false
    t.string "name", null: false
    t.bigint "heavenly_stem_id", null: false
    t.bigint "earthly_branch_id", null: false
    t.integer "heavenly_void", null: false, comment: "0: 戌亥天中殺, 1: 申酉天中殺, 2: 午未天中殺, 3: 辰已天中殺, 4: 寅卯天中殺, 5: 子丑天中殺"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["earthly_branch_id"], name: "index_sexagenary_cycles_on_earthly_branch_id"
    t.index ["heavenly_stem_id"], name: "index_sexagenary_cycles_on_heavenly_stem_id"
  end

  create_table "ten_major_stars", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "yin_yang", null: false
    t.bigint "element_id", null: false
    t.string "compatibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_ten_major_stars_on_element_id"
  end

  add_foreign_key "earthly_branches", "elements"
  add_foreign_key "earthly_branches", "heavenly_stems", column: "first_stem_id"
  add_foreign_key "earthly_branches", "heavenly_stems", column: "second_stem_id"
  add_foreign_key "earthly_branches", "heavenly_stems", column: "third_stem_id"
  add_foreign_key "fortune_analyses", "sexagenary_cycles", column: "sexagenary_cycle_day_id"
  add_foreign_key "fortune_analyses", "sexagenary_cycles", column: "sexagenary_cycle_month_id"
  add_foreign_key "fortune_analyses", "sexagenary_cycles", column: "sexagenary_cycle_year_id"
  add_foreign_key "heavenly_stems", "elements"
  add_foreign_key "sexagenary_cycles", "earthly_branches"
  add_foreign_key "sexagenary_cycles", "heavenly_stems"
  add_foreign_key "ten_major_stars", "elements"
end
