json.(@profile, :id, :first_name, :born, :birth_city_id, :residence_city_id,
  :birth_country_id, :residence_country_id, :register_step, :gender)

if @profile.user.permit('see-name', @current_user)
  json.last_name profile.last_name
else
  json.last_name profile.hidden_last_name
end

json.avatar do
  if @profile.user.permit('see-avatar', @current_user)
    json.original @profile.avatar.url
    json.small @profile.avatar.small.url
    json.medium @profile.avatar.medium.url
    json.large @profile.avatar.large.url
    json.extralarge @profile.avatar.extralarge.url
  else
    json.original @profile.avatar.default_url
    json.small @profile.avatar.small.default_url
    json.medium @profile.avatar.medium.default_url
    json.large @profile.avatar.large.default_url
    json.extralarge @profile.avatar.extralarge.default_url
  end
end