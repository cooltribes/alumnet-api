json.array! @cities do |city|
  json.id city.id
  json.name city.name
  json.country city.try(:country).try(:name)
  json.country_id city.try(:country).try(:id)
end