json.(@profile, :id, :first_name, :last_name, :born, :register_step, :created_at)

json.avatar do
  json.original @profile.avatar.url
  json.small @profile.avatar.small.url
  json.medium @profile.avatar.medium.url
  json.large @profile.avatar.large.url
  json.extralarge @profile.avatar.extralarge.url
end

if @profile.birth_city.present?
  json.birth_city do
    json.id @profile.birth_city.id
    json.text @profile.birth_city.name
  end
else
  json.birth_city nil
end

if @profile.birth_country.present?
  json.birth_country do
    json.id @profile.birth_country.id
    json.text @profile.birth_country.name
  end
else
  json.birth_country nil
end

if @profile.residence_city.present?
  json.residence_city do
    json.id @profile.residence_city.id
    json.text @profile.residence_city.name
  end
else
  json.residence_city nil
end

if @profile.residence_country.present?
  json.residence_country do
    json.id @profile.residence_country.id
    json.text @profile.residence_country.name
  end
else
  json.residence_country nil
end

if @profile.last_experience.present?
  json.last_experience @profile.last_experience.name
else
  json.last_experience nil
end

