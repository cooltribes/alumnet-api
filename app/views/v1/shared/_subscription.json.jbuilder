json.(user_subscription, :id)

json.user_subscription do
  json.id user_subscription.id
  json.start_date user_subscription.start_date
  json.end_date user_subscription.end_date
  json.lifetime user_subscription.lifetime
end

user = user_subscription.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end