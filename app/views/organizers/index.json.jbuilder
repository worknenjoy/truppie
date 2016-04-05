json.array!(@organizers) do |organizer|
  json.extract! organizer, :id
  json.extract! organizer, :name 
end
