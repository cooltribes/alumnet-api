json.(comment, :id, :comment, :created_at)

json.user do
  json.(comment.user, :id, :name, :email)

  json.avatar do
    json.thumb comment.user.avatar.thumb.url
  end
end

json.likes_count comment.likes_count
json.you_like comment.has_like_for?(current_user)

condition = comment.user == current_user
json.permissions do
  json.canEdit = condition
  json.canDelete = condition
end