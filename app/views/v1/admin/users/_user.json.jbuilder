json.(user, :id, :name, :email, :created_at)

json.status user.get_status_info

json.avatar do
  json.original user.avatar.url
  json.small user.avatar.small.url
  json.medium user.avatar.medium.url
  json.large user.avatar.large.url
  json.extralarge user.avatar.extralarge.url
end

profile = user.profile
json.profileData do
  json.first_name profile.first_name
  json.last_name profile.last_name
  json.born profile.born
  json.register_step profile.register_step
  json.gender profile.gender

  json.birth_city do
    json.id profile.birth_city.id
    json.text profile.birth_city.name
  end
  json.birth_country do
    json.id profile.birth_country.id
    json.text profile.birth_country.name
  end
  json.residence_city do
    json.id profile.residence_city.id
    json.text profile.residence_city.name
  end
  json.residence_country do
    json.id profile.residence_country.id
    json.text profile.residence_country.name
  end
  json.local_committee profile.local_committee
end

json.is_alumnet_admin user.is_alumnet_admin?
json.is_system_admin user.is_system_admin?
