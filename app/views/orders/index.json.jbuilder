json.array!(@orders) do |order|
  json.extract! order, :id, :own_id, :tour_id, :user_id, :status, :price, :discount
  json.url order_url(order, format: :json)
end
