json.(friendship, :id, :user_id, :friend_id, :accepted)

json.friendship_type friendship.friendship_type(current_user)

requester = friendship.user
friend = friendship.friend

json.requester do
  json.id requester.id
  json.name requester.permit_name(current_user)

  if requester.permit('see-avatar', current_user)
    json.avatar requester.avatar.large.url
  else
    json.avatar requester.avatar.large.default_url
  end
end

json.friend do
  json.id friend.id
  json.name friend.permit_name(current_user)

  if friend.permit('see-avatar', current_user)
    json.avatar friend.avatar.large.url
  else
    json.avatar friend.avatar.large.default_url
  end
end