#json.extract! @response_json

json.array!(@response_json["data"]) do |event|
  json.extract! event, "description"
  json.extract! event, "name"
end