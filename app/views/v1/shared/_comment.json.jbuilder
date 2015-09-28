json.(comment, :id, :comment, :markup_comment, :created_at)

json.user do
  json.(comment.user, :id, :email)
  json.name comment.user.permit_name(current_user)
  if comment.user.permit('see-avatar', current_user)
    json.avatar comment.user.avatar.medium.url
  else
    json.avatar comment.user.avatar.medium.default_url
  end
end

json.likes_count comment.likes_count
json.you_like comment.has_like_for?(current_user)

json.permissions do
  json.canEdit comment.can_edited_by(current_user)
  json.canDelete comment.can_deleted_by(current_user)
end