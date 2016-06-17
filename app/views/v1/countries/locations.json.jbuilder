json.array! @locations do |location|
  json.id location.id
  json.name location.name
  json.country location.try(:country).try(:name)
  json.country_id location.try(:country).try(:id)
end