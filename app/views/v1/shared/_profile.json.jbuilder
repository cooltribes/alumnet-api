json.(profile, :id, :first_name, :last_name, :born, :register_step, :created_at)

json.avatar do
  if profile.user.permit('see-avatar', current_user)
    json.original profile.avatar.url
    json.small profile.avatar.small.url
    json.medium profile.avatar.medium.url
    json.large profile.avatar.large.url
    json.extralarge profile.avatar.extralarge.url
  else
    json.original profile.avatar.default_url
    json.small profile.avatar.small.default_url
    json.medium profile.avatar.medium.default_url
    json.large profile.avatar.large.default_url
    json.extralarge profile.avatar.extralarge.default_url
  end
end

if prolife.birth_city.present?
  json.birth_city do
    json.id prolife.birth_city.id
    json.text prolife.birth_city.name
  end
else
  json.birth_city nil
end

if prolife.birth_country.present?
  json.birth_country do
    json.id prolife.birth_country.id
    json.text prolife.birth_country.name
  end
else
  json.birth_country nil
end

if prolife.residence_city.present?
  json.residence_city do
    json.id prolife.residence_city.id
    json.text prolife.residence_city.name
  end
else
  json.residence_city nil
end

if prolife.residence_country.present?
  json.residence_country do
    json.id prolife.residence_country.id
    json.text prolife.residence_country.name
  end
else
  json.residence_country nil
end

if prolife.last_experience.present?
  json.last_experience prolife.last_experience.name
else
  json.last_experience nil
end