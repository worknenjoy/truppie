json.array!(@organizers) do |organizer|
  json.extract! organizer, :id
  json.url organizer_url(organizer, format: :json)
end
