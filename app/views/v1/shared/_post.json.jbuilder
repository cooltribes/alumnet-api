json.(post, :id, :body, :post_type, :created_at, :last_comment_at)

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
json.likes post.likes.without_user(current_user) do |like|
  json.(like, :id, :created_at)
  json.user do
    json.id like.user.id
    json.name like.user.permit_name(current_user)
    if like.user.permit('see-avatar', current_user)
      json.avatar like.user.avatar.medium.url
    else
      json.avatar like.user.avatar.medium.default_url
    end
  end
end

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

json.user_tags_list post.user_tags do |user|
  json.id user.id
  json.name user.permit_name(current_user)
end

json.preview do
  json.url post.url
  json.title post.url_title
  json.description post.url_description
  json.image post.url_image
end

json.content do
  if post.content
    json.partial! 'v1/shared/shared_post', post: post.content
  else
    json.nil!
  end
end