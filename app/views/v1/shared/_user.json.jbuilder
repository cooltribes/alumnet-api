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