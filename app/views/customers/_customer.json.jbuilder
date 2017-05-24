json.extract! customer, :id, :token, :email, :user_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
