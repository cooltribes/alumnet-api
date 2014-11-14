json.(friend, :id, :email, :name)

json.avatar do
  json.original friend.avatar.url
  json.thumb friend.avatar.thumb.url
end