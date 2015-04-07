json.(user, :id, :member)

json.name user.permit_name(current_user)
json.email user.permit_email(current_user)

json.last_experience user.permit_last_experience(current_user)



json.avatar do
  if user.permit('see-avatar', current_user)
    json.original user.avatar.url
    json.small user.avatar.small.url
    json.medium user.avatar.medium.url
    json.large user.avatar.large.url
    json.extralarge user.avatar.extralarge.url
  else
    json.original user.avatar.default_url
    json.small user.avatar.small.default_url
    json.medium user.avatar.medium.default_url
    json.large user.avatar.large.default_url
    json.extralarge user.avatar.extralarge.default_url
  end
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
json.is_premium user.is_premium?

json.friends_count user.permit_friends_count(current_user)
json.mutual_friends_count current_user.mutual_friends_count(user)
