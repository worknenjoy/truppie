json.extract! tour_picture, :id, :photo, :tour_id, :created_at, :updated_at
json.url tour_picture_url(tour_picture, format: :json)
