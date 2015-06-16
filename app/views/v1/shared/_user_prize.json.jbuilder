json.(user_prize, :id)

json.user_prize do
  json.id user_prize.id
  json.price user_prize.price
  json.status user_prize.status
  json.created_at user_prize.created_at
  json.updated_at user_prize.updated_at
  json.prize_type user_prize.prize_type
  json.remaining_quantity user_prize.remaining_quantity
end

user = user_prize.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end

prize = user_prize.prize
json.prize do
  json.id prize.id
  json.name prize.name
  json.description prize.description
  json.price prize.price
  json.status prize.status
  json.prize_type prize.prize_type
  json.created_at prize.created_at
  json.updated_at prize.updated_at
  json.quantity prize.quantity
end