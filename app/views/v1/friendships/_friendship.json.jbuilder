json.(friendship, :id, :user_id, :friend_id, :accepted)
json.requester do
  json.(friendship.user, :id, :name, :avatar)
end
json.friend do
  json.(friendship.friend, :id, :name, :avatar)
end