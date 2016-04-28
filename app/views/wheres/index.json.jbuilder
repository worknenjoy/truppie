json.array!(@wheres) do |where|
  json.extract! where, :id
  json.extract! where, :name
end