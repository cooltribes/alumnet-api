json.(comment, :id, :comment, :created_at)

json.user do
  json.(comment.user, :id, :name, :email)

  json.avatar comment.user.avatar.medium.url
end

json.likes_count comment.likes_count
json.you_like comment.has_like_for?(current_user)

json.permissions do
  json.canEdit comment.can_edited_by(current_user)
  json.canDelete comment.can_deleted_by(current_user)
end