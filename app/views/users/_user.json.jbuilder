json.extract! user, :id, :email, :phone, :first_name, :last_name, :organization_id, :created_at, :updated_at
json.url user_url(user, format: :json)
