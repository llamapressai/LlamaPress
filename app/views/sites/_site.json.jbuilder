json.extract! site, :id, :organization_id, :name, :slug, :created_at, :updated_at
json.url site_url(site, format: :json)
