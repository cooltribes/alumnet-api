json.(@profile, :id, :first_name, :last_name, :born, :register_step, :created_at)

# json.birth_country @profile.get_birth_country_info
# json.birth_city @profile.get_birth_city_info
# json.residence_country @profile.get_residence_country_info
# json.residence_city @profile.get_residence_city_info
# json.local_committee @profile.local_committee

json.avatar do
  json.original @profile.avatar.url
  json.small @profile.avatar.small.url
  json.medium @profile.avatar.medium.url
  json.large @profile.avatar.large.url
  json.extralarge @profile.avatar.extralarge.url
end