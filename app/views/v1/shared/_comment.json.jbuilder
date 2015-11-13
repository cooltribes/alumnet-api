json.(comment, :id, :comment, :markup_comment, :created_at)

json.user do
  if comment.user
    json.partial! 'v1/shared/user_info', user: comment.user, current_user: current_user
  else
    json.nil!
  end
end

json.likes_count comment.likes_count
json.you_like comment.has_like_for?(current_user)

json.permissions do
  json.canEdit comment.can_edited_by(current_user)
  json.canDelete comment.can_deleted_by(current_user)
end