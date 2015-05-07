json.(region, :id, :name)

json.countries region.countries_info

json.admins do
  json.array! region.admins do |user|
    json.id user.id
    json.name user.name
    json.email user.email
    json.avatar user.avatar.medium.url
  end
end