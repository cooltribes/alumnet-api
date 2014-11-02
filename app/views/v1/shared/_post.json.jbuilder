json.(post, :id, :body, :created_at)

json.user do
  json.(post.user, :id, :name, :email)

  json.avatar do
    json.thumb post.user.avatar.thumb.url
  end
end

condition = post.user == current_user
json.permissions do
  json.canEdit = condition
  json.canDelete = condition
end