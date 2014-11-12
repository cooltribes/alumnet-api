json.(friendship, :id, :user_id, :friend_id, :accepted)

json.friendship_type friendship_type

json.requester do
  json.(friendship.user, :id, :name)
  json.thumb friendship.user.avatar.thumb.url
end

json.friend do
  json.(friendship.friend, :id, :name)
  json.thumb friendship.friend.avatar.thumb.url
end