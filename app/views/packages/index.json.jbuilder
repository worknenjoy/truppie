json.array!(@packages) do |package|
  json.extract! package, :id, :value, :included
  json.url package_url(package, format: :json)
end
