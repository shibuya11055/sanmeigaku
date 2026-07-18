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

ActiveRecord::Schema[8.0].define(version: 2026_07_19_001000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clients", comment: "クライアント情報テーブル", force: :cascade do |t|
    t.string "fullname", null: false, comment: "クライアントの名前（ニックネーム可）"
    t.date "birthday", null: false, comment: "生年月日"
    t.integer "gender", null: false, comment: "性別 0=男性(male), 1=女性(female)"
    t.integer "blood_type", comment: "血液型 0=A型, 1=B型, 2=O型, 3=AB型, 4=不明(unknown)"
    t.integer "marital_status", comment: "婚姻状況 0=未婚(single), 1=既婚(married), 2=離婚(divorced), 3=死別(widowed)"
    t.string "birthplace", comment: "出生地（都道府県など）"
    t.text "memo", comment: "自由記述欄"
    t.bigint "user_id", null: false, comment: "所有するユーザーID"
    t.bigint "job_id", comment: "職業ID"
    t.bigint "occupation_id", comment: "職種ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prefecture_id"
    t.index ["job_id"], name: "index_clients_on_job_id"
    t.index ["occupation_id"], name: "index_clients_on_occupation_id"
    t.index ["user_id", "fullname"], name: "index_clients_on_user_id_and_fullname"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "fortune_records", force: :cascade do |t|
    t.bigint "client_id", null: false, comment: "クライアントID（外部キー）"
    t.datetime "start_at", null: false, comment: "占い開始日時"
    t.datetime "end_at", null: false, comment: "占い終了日時"
    t.integer "amount", null: false, comment: "占いの金額"
    t.text "content", null: false, comment: "占いのカルテ（テキスト情報）"
    t.integer "category", null: false, comment: "相談内容カテゴリ(enum)"
    t.integer "consultation_method", null: false, comment: "相談手段(enum)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_fortune_records_on_client_id"
  end

  create_table "jobs", comment: "職業マスタテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "職業名（例: \"会社員\"）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_jobs_on_name", unique: true
  end

  create_table "occupations", comment: "職種マスタテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "職種名（例: \"エンジニア\"）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_occupations_on_name", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.integer "status"
    t.string "plan_name"
    t.integer "amount"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "fullname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp_secret"
    t.boolean "otp_enabled", default: false, null: false
    t.text "backup_codes"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "clients", "jobs"
  add_foreign_key "clients", "occupations"
  add_foreign_key "clients", "users"
  add_foreign_key "fortune_records", "clients"
  add_foreign_key "subscriptions", "users"
end
