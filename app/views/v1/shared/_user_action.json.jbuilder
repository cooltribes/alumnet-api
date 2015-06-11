json.(user_action, :id)

json.user_action do
  json.id user_action.id
  json.value user_action.value
  json.generator_id user_action.generator_id
  json.generator_type user_action.generator_type
  json.created_at user_action.created_at
  json.updated_at user_action.updated_at
end

user = user_action.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end

action = user_action.action
json.action do
  json.id action.id
  json.name action.name
  json.description action.description
  json.status action.status
  json.value action.value
  json.created_at action.created_at
  json.updated_at action.updated_at
  json.key_name action.key_name
end

invited_user = user_action.invited_user
json.invited_user do
  json.id invited_user.id
  json.name invited_user.name
  json.avatar invited_user.avatar.large.url
  json.last_experience invited_user.last_experience.try(:name)
end