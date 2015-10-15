# The permit_methods are in ProfileDecorator
json.(profile, :id, :first_name, :last_name, :register_step, :created_at, :points, :gender, :professional_headline)

json.born profile.permit_born(current_user)

json.birth_city profile.permit_birth_city(current_user)
json.birth_country profile.permit_birth_country(current_user)

json.residence_city profile.permit_residence_city(current_user)
json.residence_country profile.permit_residence_country(current_user)

json.last_experience profile.permit_last_experience(current_user)

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

json.cover do
  json.original profile.cover.url
  json.main profile.cover.main.url
  json.position profile.cover_position
end

json.role profile.user.role
json.created_by_admin profile.user.created_by_admin
