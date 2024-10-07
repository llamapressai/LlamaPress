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

ActiveRecord::Schema[7.2].define(version: 2024_10_07_180243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

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

  create_table "page_histories", force: :cascade do |t|
    t.text "content"
    t.bigint "page_id", null: false
    t.text "prompt"
    t.text "user_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_histories_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.text "content"
    t.string "slug"
    t.string "prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.index ["site_id"], name: "index_pages_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_sites_on_organization_id"
    t.index ["slug"], name: "index_sites_on_slug", unique: true
  end

  create_table "snippets", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.bigint "site_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_snippets_on_site_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.jsonb "data"
    t.bigint "site_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_submissions_on_site_id"
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
    t.bigint "default_site_id"
    t.index ["default_site_id"], name: "index_users_on_default_site_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "page_histories", "pages"
  add_foreign_key "pages", "organizations", on_delete: :nullify
  add_foreign_key "pages", "sites"
  add_foreign_key "sites", "organizations"
  add_foreign_key "snippets", "sites"
  add_foreign_key "submissions", "sites"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "sites", column: "default_site_id"
end
