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

ActiveRecord::Schema[7.2].define(version: 2024_09_08_173500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "phone"
    t.text "notes"
    t.string "state"
    t.string "street_address"
    t.string "zip_code"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "static_web_page_histories", force: :cascade do |t|
    t.text "content"
    t.bigint "static_web_page_id", null: false
    t.text "prompt"
    t.text "user_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["static_web_page_id"], name: "index_static_web_page_histories_on_static_web_page_id"
  end

  create_table "static_web_pages", force: :cascade do |t|
    t.bigint "static_web_site_id", null: false
    t.text "content"
    t.string "slug"
    t.string "prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.index ["static_web_site_id"], name: "index_static_web_pages_on_static_web_site_id"
  end

  create_table "static_web_sites", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_static_web_sites_on_organization_id"
    t.index ["slug"], name: "index_static_web_sites_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "static_web_page_histories", "static_web_pages"
  add_foreign_key "static_web_pages", "organizations", on_delete: :nullify
  add_foreign_key "static_web_pages", "static_web_sites"
  add_foreign_key "static_web_sites", "organizations"
  add_foreign_key "users", "organizations"
end
