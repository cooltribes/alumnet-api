  json.(user, :id)
  json.name user.permit_name(current_user)
  json.residence_city user.profile.permit_residence_city(current_user)
  json.residence_country user.profile.permit_residence_country(current_user)
  if user.permit('see-avatar', current_user)
    json.avatar user.avatar.large.url
  else
    json.avatar user.avatar.large.default_url
  end
  if user.cover
    json.cover user.cover.card.url
  else
    json.cover nil
  end