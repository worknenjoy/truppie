json.extract! comment, :id, :title, :comment, :user_id, :guidebook_id, :parent_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
