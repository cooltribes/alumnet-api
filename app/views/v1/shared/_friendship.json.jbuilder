json.(friendship, :id, :user_id, :friend_id, :accepted)

type = friendship.friendship_type(current_user)
json.friendship_type type

json.requester do
  requester = friendship.user
  json.id requester.id
  if requester.permit('see-name', current_user)
    json.name requester.name
  else
    json.name requester.hidden_name
  end
  if requester.permit('see-avatar', current_user)
    json.avatar friendship.user.avatar.large.url
  else
    json.avatar friendship.user.avatar.large.default_url
  end
end

json.friend do
  friend = friendship.friend
  json.id friend.id
  if friend.permit('see-name', current_user)
    json.name friend.name
  else
    json.name friend.hidden_name
  end
  if friend.permit('see-avatar', current_user)
    json.avatar friendship.user.avatar.large.url
  else
    json.avatar friendship.user.avatar.large.default_url
  end
end