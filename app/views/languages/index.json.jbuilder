json.array!(@languages) do |language|
  json.extract! language, :id
  json.extract! language, :name
end