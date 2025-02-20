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

ActiveRecord::Schema[8.0].define(version: 2025_02_20_161650) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "branches", id: :serial, force: :cascade do |t|
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
    t.index ["element_id"], name: "index_branches_on_element_id"
    t.index ["first_stem_id"], name: "index_branches_on_first_stem_id"
    t.index ["second_stem_id"], name: "index_branches_on_second_stem_id"
    t.index ["third_stem_id"], name: "index_branches_on_third_stem_id"
  end

  create_table "elements", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fortune_analyses", force: :cascade do |t|
    t.date "birthday", null: false
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

  create_table "sexagenary_cycles", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.bigint "stem_id", null: false
    t.bigint "branch_id", null: false
    t.integer "heavenly_void", null: false, comment: "0: 戌亥天中殺, 1: 申酉天中殺, 2: 午未天中殺, 3: 辰已天中殺, 4: 寅卯天中殺, 5: 子丑天中殺"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_sexagenary_cycles_on_branch_id"
    t.index ["stem_id"], name: "index_sexagenary_cycles_on_stem_id"
  end

  create_table "stem_ten_star_mappings", id: :serial, comment: "日干気、他気、十大主星の関係", force: :cascade do |t|
    t.bigint "main_stem_id", null: false, comment: "日干気"
    t.bigint "sub_stem_id", null: false, comment: "他気"
    t.bigint "ten_major_star_id", null: false, comment: "十大主星"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["main_stem_id"], name: "index_stem_ten_star_mappings_on_main_stem_id"
    t.index ["sub_stem_id"], name: "index_stem_ten_star_mappings_on_sub_stem_id"
    t.index ["ten_major_star_id"], name: "index_stem_ten_star_mappings_on_ten_major_star_id"
  end

  create_table "stems", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "yin_yang", null: false
    t.text "description"
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_stems_on_element_id"
  end

  create_table "ten_major_stars", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "yin_yang", null: false
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_ten_major_stars_on_element_id"
  end

  add_foreign_key "branches", "elements"
  add_foreign_key "branches", "stems", column: "first_stem_id"
  add_foreign_key "branches", "stems", column: "second_stem_id"
  add_foreign_key "branches", "stems", column: "third_stem_id"
  add_foreign_key "fortune_analyses", "sexagenary_cycles", column: "sexagenary_cycle_day_id"
  add_foreign_key "fortune_analyses", "sexagenary_cycles", column: "sexagenary_cycle_month_id"
  add_foreign_key "fortune_analyses", "sexagenary_cycles", column: "sexagenary_cycle_year_id"
  add_foreign_key "sexagenary_cycles", "branches"
  add_foreign_key "sexagenary_cycles", "stems"
  add_foreign_key "stem_ten_star_mappings", "stems", column: "main_stem_id"
  add_foreign_key "stem_ten_star_mappings", "stems", column: "sub_stem_id"
  add_foreign_key "stem_ten_star_mappings", "ten_major_stars"
  add_foreign_key "stems", "elements"
  add_foreign_key "ten_major_stars", "elements"
end
