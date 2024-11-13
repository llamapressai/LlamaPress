json.extract! chat_conversation, :id, :title, :user_id, :site_id, :uuid, :created_at, :updated_at
json.url chat_conversation_url(chat_conversation, format: :json)
