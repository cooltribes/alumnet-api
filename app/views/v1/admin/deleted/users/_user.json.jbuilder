json.(user, :id, :email, :created_at)

json.name user.permit_name(current_user)

json.avatar do
  if user.permit('see-avatar', current_user)
    json.medium user.avatar.medium.url
  else
    json.medium user.avatar.medium.default_url
  end
end