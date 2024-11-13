json.extract! chat_message, :id, :content, :sender, :user_id, :chat_conversation_id, :site_id, :uuid, :created_at, :updated_at
json.url chat_message_url(chat_message, format: :json)
