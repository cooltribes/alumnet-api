json.array! @events do |event|
  json.id event.id
  json.name event.name
  json.is_admin event.is_admin?(@user)
  json.event_type event.event_type_info
  json.country event.country_info
  json.city event.city_info
  json.address event.address
  json.start_date event.start_date
end