json.array!(@tags) do |tag|
  json.extract! tag, :id
  json.extract! tag, :name
end