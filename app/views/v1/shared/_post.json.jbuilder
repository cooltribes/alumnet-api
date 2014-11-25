json.(post, :id, :body, :created_at, :last_comment_at)

json.user do
  json.(post.user, :id, :name, :email)

  json.avatar post.user.avatar.large.url
end

json.likes_count post.likes_count
json.you_like post.has_like_for?(current_user)

condition = post.user == current_user
json.permissions do
  json.canEdit = condition
  json.canDelete = condition
end