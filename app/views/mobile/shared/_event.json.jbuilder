json.(event, :id, :name, :official, :address, :start_date, :start_hour, 
  :city_id, :country_id)

json.event_type event.event_type_info
json.country event.country_info
json.city event.city_info

json.cover do
  json.card event.cover.card.url
end