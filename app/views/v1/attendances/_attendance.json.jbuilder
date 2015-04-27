json.(attendance, :id, :status, :event_id, :user_id, :created_at)

event = attendance.event
json.event do
  json.id event.id
  json.name event.name
  json.description event.description
  json.official event.official
  json.cover do
    json.main event.cover.main.url
    json.card event.cover.card.url
  end
end

user = attendance.user
json.user do
  json.id user.id
  json.name user.permit_name(current_user)
  json.last_experience user.permit_last_experience(current_user)
  if user.permit('see-avatar', current_user)
    json.avatar user.avatar.large.url
  else
    json.avatar user.avatar.large.default_url
  end
end