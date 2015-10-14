json.(like, :id, :created_at)
json.user do
  json.id like.user.id
  json.name like.user.permit_name(current_user)

  if like.user.permit('see-avatar', current_user)
    json.avatar like.user.avatar.medium.url
  else
    json.avatar like.user.avatar.medium.default_url
  end

  if like.user.id == current_user.id
    json.friendship_status "current user"
    json.friendship nil
  else
    friendship = like.user.friendship_with(current_user)
    if friendship
      json.friendship_status current_user.friendship_status_with(like.user)
      json.friendship friendship, :id, :accepted, :created_at
    else
      json.friendship_status "none"
      json.friendship nil
    end
  end
end