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

ActiveRecord::Schema[7.2].define(version: 2025_07_03_183643) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chat_conversations", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "site_id"
    t.bigint "page_id"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_chat_conversations_on_page_id"
    t.index ["site_id"], name: "index_chat_conversations_on_site_id"
    t.index ["user_id"], name: "index_chat_conversations_on_user_id"
    t.index ["uuid"], name: "index_chat_conversations_on_uuid", unique: true
  end

  create_table "chat_messages", force: :cascade do |t|
    t.text "content"
    t.integer "sender"
    t.bigint "user_id", null: false
    t.bigint "chat_conversation_id", null: false
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trace_id"
    t.string "trace_url"
    t.index ["chat_conversation_id"], name: "index_chat_messages_on_chat_conversation_id"
    t.index ["trace_id"], name: "index_chat_messages_on_trace_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
    t.index ["uuid"], name: "index_chat_messages_on_uuid", unique: true
  end

  create_table "checkpoint_blobs", primary_key: ["thread_id", "checkpoint_ns", "channel", "version"], force: :cascade do |t|
    t.text "thread_id", null: false
    t.text "checkpoint_ns", default: "", null: false
    t.text "channel", null: false
    t.text "version", null: false
    t.text "type", null: false
    t.binary "blob"
    t.index ["thread_id"], name: "checkpoint_blobs_thread_id_idx"
  end

  create_table "checkpoint_migrations", primary_key: "v", id: :integer, default: nil, force: :cascade do |t|
  end

  create_table "checkpoint_writes", primary_key: ["thread_id", "checkpoint_ns", "checkpoint_id", "task_id", "idx"], force: :cascade do |t|
    t.text "thread_id", null: false
    t.text "checkpoint_ns", default: "", null: false
    t.text "checkpoint_id", null: false
    t.text "task_id", null: false
    t.integer "idx", null: false
    t.text "channel", null: false
    t.text "type"
    t.binary "blob", null: false
    t.text "task_path", default: "", null: false
    t.index ["thread_id"], name: "checkpoint_writes_thread_id_idx"
  end

  create_table "checkpoints", primary_key: ["thread_id", "checkpoint_ns", "checkpoint_id"], force: :cascade do |t|
    t.text "thread_id", null: false
    t.text "checkpoint_ns", default: "", null: false
    t.text "checkpoint_id", null: false
    t.text "parent_checkpoint_id"
    t.text "type"
    t.jsonb "checkpoint", null: false
    t.jsonb "metadata", default: {}, null: false
    t.index ["thread_id"], name: "checkpoints_thread_id_idx"
  end

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

  create_table "hello_dolly_greetings", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "email", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["email"], name: "index_leads_on_email", unique: true
  end

  create_table "message_reactions", force: :cascade do |t|
    t.bigint "chat_message_id"
    t.bigint "user_id"
    t.string "reaction_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "feedback"
    t.bigint "page_history_id"
    t.index ["chat_message_id", "user_id"], name: "index_message_reactions_on_chat_message_id_and_user_id", unique: true
    t.index ["chat_message_id"], name: "index_message_reactions_on_chat_message_id"
    t.index ["page_history_id"], name: "index_message_reactions_on_page_history_id"
    t.index ["user_id"], name: "index_message_reactions_on_user_id"
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
    t.bigint "human_chat_message_id"
    t.bigint "ai_chat_message_id"
    t.index ["ai_chat_message_id"], name: "index_page_histories_on_ai_chat_message_id"
    t.index ["human_chat_message_id"], name: "index_page_histories_on_human_chat_message_id"
    t.index ["page_id"], name: "index_page_histories_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.text "content"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.integer "current_version_id"
    t.integer "wordpress_page_id"
    t.index ["current_version_id"], name: "index_pages_on_current_version_id"
    t.index ["site_id"], name: "index_pages_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "wordpress_api_encoded_token"
    t.bigint "home_page_id"
    t.bigint "after_submission_page_id"
    t.text "system_prompt"
    t.string "llamabot_agent_name"
    t.index ["after_submission_page_id"], name: "index_sites_on_after_submission_page_id"
    t.index ["home_page_id"], name: "index_sites_on_home_page_id"
    t.index ["organization_id"], name: "index_sites_on_organization_id"
    t.index ["slug"], name: "index_sites_on_slug", unique: true
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
    t.string "public_id"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "mixpanel_profile_last_set_at"
    t.string "api_token"
    t.integer "tutorial_step", default: 0
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "subscription_plan"
    t.datetime "stripe_subscription_start_date"
    t.datetime "stripe_subscription_end_date"
    t.boolean "admin", default: false
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["default_site_id"], name: "index_users_on_default_site_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_conversations", "pages"
  add_foreign_key "chat_conversations", "sites"
  add_foreign_key "chat_conversations", "users"
  add_foreign_key "chat_messages", "chat_conversations"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "message_reactions", "chat_messages"
  add_foreign_key "message_reactions", "page_histories", on_delete: :nullify
  add_foreign_key "message_reactions", "users"
  add_foreign_key "page_histories", "chat_messages", column: "ai_chat_message_id"
  add_foreign_key "page_histories", "chat_messages", column: "human_chat_message_id"
  add_foreign_key "page_histories", "pages"
  add_foreign_key "pages", "organizations", on_delete: :nullify
  add_foreign_key "pages", "sites"
  add_foreign_key "sites", "organizations"
  add_foreign_key "sites", "pages", column: "after_submission_page_id"
  add_foreign_key "sites", "pages", column: "home_page_id"
  add_foreign_key "submissions", "sites"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "sites", column: "default_site_id"
end
