json.array! @locations do |location|
  json.id location.id
  json.name location.name
  json.country location.try(:country).try(:name)
end