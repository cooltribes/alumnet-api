json.(post, :id, :body, :created_at, :last_comment_at)

json.user do
  json.(post.user, :id, :name, :email)
  json.avatar post.user.avatar.large.url
end

json.likes_count post.likes_count
json.you_like post.has_like_for?(current_user)

json.postable_info post.postable_info

json.permissions do
  json.canEdit post.can_edited_by(current_user)
  json.canDelete post.can_deleted_by(current_user)
end

json.resource_path post.resource_path
