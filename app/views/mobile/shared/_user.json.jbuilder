json.(user, :id, :member, :online)

json.name user.permit_name(current_user)

json.last_experience user.permit_last_experience(current_user)

json.avatar do
  if user.permit('see-avatar', current_user)
    json.large user.avatar.large.url
  else
    json.large user.avatar.large.default_url
  end
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

if user.id == current_user.id
  json.approval_status "user"
else
  approval_request = user.approval_with(current_user)
  if approval_request
    json.approval_status current_user.approval_status_with(user)
    json.approval_update_at approval_request.updated_at
  else
    json.approval_status "none"
  end
end

