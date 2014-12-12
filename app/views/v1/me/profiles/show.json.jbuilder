json.(@profile, :id, :first_name, :last_name, :born, :birth_city_id, :residence_city_id,
  :birth_country_id, :residence_country_id, :register_step)

json.avatar do
  json.original @profile.avatar.url
  json.small @profile.avatar.small.url
  json.medium @profile.avatar.medium.url
  json.large @profile.avatar.large.url
  json.extralarge @profile.avatar.extralarge.url
end