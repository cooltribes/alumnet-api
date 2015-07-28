json.(subscription, :id)

json.subscription do
  json.id subscription.id
  json.start_date subscription.start_date
  json.end_date subscription.end_date
  json.lifetime subscription.lifetime
end

user = subscription.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end