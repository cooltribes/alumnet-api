json.(match, :id, :created_at, :updated_at, :applied)
json.user_has_invitation match.has_invitation
if match.user
  json.user do
    json.(match.user, :id)
    json.name match.user.permit_name(current_user)
    json.last_experience match.user.permit_last_experience(current_user)
    if match.user.permit('see-avatar', current_user)
      json.avatar match.user.avatar.large.url
    else
      json.avatar match.user.avatar.large.default_url
    end
  end
else
  json.user nil
end