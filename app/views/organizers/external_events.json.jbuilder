#json.extract! @response_json

json.array!(@response_json["data"]) do |event|
  json.extract! event, "description"
  json.extract! event, "name"
  json.extract! event, "start_time"
  json.extract! event, "end_time" if event["end_time"]
  json.extract! event, "id"
end