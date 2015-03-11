json.(event, :id, :name, :description, :official, :address, :start_date, :start_hour,
  :end_date, :end_hour, :capacity, :city_id, :country_id, :created_at)

json.event_type event.event_type_info
json.country event.country_info
json.city event.city_info

json.cover do
  json.main event.cover.main.url
  json.card event.cover.card.url
end

attendance = event.attendance_for(current_user)

if attendance
  json.attendance_info attendance, :id, :status, :event_id, :user_id, :created_at
else
  json.attendance_info nil
end