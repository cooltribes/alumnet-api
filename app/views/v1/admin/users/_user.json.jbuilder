json.(user, :id, :name, :email, :created_at)

json.status user.get_status_info
json.member user.get_member_info

json.avatar do
  json.original user.avatar.url
  json.small user.avatar.small.url
  json.medium user.avatar.medium.url
  json.large user.avatar.large.url
  json.extralarge user.avatar.extralarge.url
end

profile = user.profile
json.profileData do
  json.first_name profile.first_name || nil
  json.last_name profile.last_name || nil
  json.born profile.born || nil
  json.register_step profile.register_step || nil
  json.gender profile.gender || nil

  if profile.birth_city.present?
    json.birth_city do
      json.id profile.birth_city.id
      json.text profile.birth_city.name
    end
  else
    json.birth_city nil
  end

  if profile.birth_country.present?
    json.birth_country do
      json.id profile.birth_country.id
      json.text profile.birth_country.name
    end
  else
    json.birth_country nil
  end

  if profile.residence_city.present?
    json.residence_city do
      json.id profile.residence_city.id
      json.text profile.residence_city.name
    end
  else
    json.residence_city nil
  end

  if profile.residence_country.present?
    json.residence_country do
      json.id profile.residence_country.id
      json.text profile.residence_country.name
    end
  else
    json.residence_country nil
  end

  if profile.local_committee.present?
    json.local_committee profile.local_committee
  else
    json.local_committee nil
  end
end

json.is_alumnet_admin user.is_alumnet_admin?
json.is_system_admin user.is_system_admin?
json.is_regional_admin user.is_regional_admin?
json.is_nacional_admin user.is_nacional_admin?

json.admin_location user.admin_location_info
