json.(email_preference, :id, :value, :created_at, :updated_at)

user = email_preference.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end

group = email_preference.group
json.group_id group.id
json.group_name group.name

json.group do
  json.id group.id
  json.name group.name
  json.short_description group.short_description
  json.official group.official
  json.created_at group.created_at
end