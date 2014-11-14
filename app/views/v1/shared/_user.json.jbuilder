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

json.friendship_status current_user.friendship_status_with(user)

friendship = current_user.friendship_with(user)
json.friendship(current_user.friendship_with(user), :id, :accepted) if friendship.present?
