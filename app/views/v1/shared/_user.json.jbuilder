json.(user, :id, :name, :email)

json.last_experience user.last_experience.try(:name)

json.avatar do
  json.original user.avatar.url
  json.small user.avatar.small.url
  json.medium user.avatar.medium.url
  json.large user.avatar.large.url
  json.extralarge user.avatar.extralarge.url
end

json.groups do
  json.array! user.groups.pluck(:id)
end

if user.id == current_user.id
  json.friendship_status "current user"
  json.friendship nil
else
  friendship = user.friendship_with(current_user)
  if friendship
    json.friendship_status current_user.friendship_status_with(user)
    json.friendship friendship, :id, :accepted, :created_at
  else
    json.friendship_status "none"
    json.friendship nil
  end
end

json.is_alumnet_admin user.is_alumnet_admin?
json.is_system_admin user.is_system_admin?

json.friends_count user.friends_count
json.pending_received_friendships_count user.pending_received_friendships_count
json.pending_sent_friendships_count user.pending_sent_friendships_count
