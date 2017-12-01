json.array!(@tours) do |tour|
  json.extract! tour, :id, :title, :description, :rating, :price, :address, :status, :wheres
  json.thumbnail tour.picture.url(:thumbnail)
  json.url tour_url(tour)
end
