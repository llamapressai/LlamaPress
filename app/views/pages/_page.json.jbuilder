json.extract! page, :id, :site_id, :content, :slug, :prompt, :created_at, :updated_at
json.url page_url(page, format: :json)
