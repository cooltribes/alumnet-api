json.(comment, :comment, :created_at)

json.user do
  json.(comment.user, :id, :name, :email)

  json.avatar do
    json.thumb comment.user.avatar.thumb.url
  end
end