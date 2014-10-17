json.(user, :id, :name, :email)

json.avatar do
  json.original user.avatar.url
  json.thumb user.avatar.thumb.url
end