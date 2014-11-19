json.(user, :id, :name, :email)

json.avatar do
  json.original user.avatar.url
  json.thumb user.avatar.thumb.url
end

json.groups do
  json.array! user.groups.pluck(:id)
end

json.profile do
  user.profile
end

friendship = user.friendship_with(current_user)
if friendship
  json.friendship_status current_user.friendship_status_with(user)
  json.friendship friendship, :id, :accepted, :created_at
end