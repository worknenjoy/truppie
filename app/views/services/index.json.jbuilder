json.array!(@services) do |service|
  json.extract! service, :id, :value, :included
  json.url service_url(service, format: :json)
end
