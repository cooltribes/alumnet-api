json.(friendship, :id, :user_id, :friend_id, :accepted)

type = friendship.friendship_type(user)
json.friendship_type type

## if i sent a friendship, the friend is the friend of friendship
## but if i received a friendship, the friend is the user of friedship

if type == 'sent' ## this is a direct_friendship
  json.requester do
    json.(friendship.user, :id, :name)
    json.avatar friendship.user.avatar.large.url
  end

  json.friend do
    json.(friendship.friend, :id, :name)
    json.avatar friendship.friend.avatar.large.url
  end

elsif type == 'received' ## this is a inverse_friendship
   json.requester do
    json.(friendship.user, :id, :name)
    json.avatar friendship.user.avatar.large.url
  end

  json.friend do
    json.(friendship.friend, :id, :name)
    json.avatar friendship.friend.avatar.large.url
  end

end