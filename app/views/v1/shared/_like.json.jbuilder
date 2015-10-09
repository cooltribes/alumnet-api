json.(like, :id, :created_at)
json.user do
  json.id like.user.id
  json.name like.user.permit_name(current_user)
  if like.user.permit('see-avatar', current_user)
    json.avatar like.user.avatar.medium.url
  else
    json.avatar like.user.avatar.medium.default_url
  end
end