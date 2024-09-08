json.extract! static_website, :id, :organization_id, :name, :slug, :created_at, :updated_at
json.url static_website_url(static_website, format: :json)
