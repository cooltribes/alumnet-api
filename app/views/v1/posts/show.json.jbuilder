json.(@post, :body, :created_at)

json.user do
  json.(@post.user, :id, :name, :email)

  json.avatar do
    json.thumb @post.user.avatar.thumb.url
  end
end