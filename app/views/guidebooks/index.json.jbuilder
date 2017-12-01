json.array!(@guidebooks) do |g|
  json.extract! g, :id, :title, :description, :price, :rating, :status, :wheres
  json.thumbnail g.picture.url(:thumbnail)
  json.url guidebook_url(g)
end
