json.(email_preference, :id, :name, :value, :created_at, :updated_at)

user = email_preference.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end