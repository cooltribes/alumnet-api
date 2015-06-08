json.(post, :id, :body, :created_at, :last_comment_at)

json.user do
  json.(post.user, :id)
  json.name post.user.permit_name(current_user)
  if post.user.permit('see-avatar', current_user)
    json.avatar post.user.avatar.large.url
  else
    json.avatar post.user.avatar.large.default_url
  end
end

json.likes_count post.likes_count
json.you_like post.has_like_for?(current_user)

json.postable_info post.postable_info(current_user)

json.permissions do
  json.canEdit post.can_edited_by(current_user)
  json.canDelete post.can_deleted_by(current_user)
end

json.resource_path post.resource_path

if post.pictures.any?
  json.pictures post.pictures, partial: 'v1/shared/picture', as: :picture, current_user: current_user
else
  json.pictures nil
end
