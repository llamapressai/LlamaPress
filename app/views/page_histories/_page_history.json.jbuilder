json.extract! page_history, :id, :content, :page_id, :prompt, :user_message, :created_at, :updated_at
json.url page_history_url(page_history, format: :json)
