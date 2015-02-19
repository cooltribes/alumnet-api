json.(membership, :id, :approved, :group_id, :user_id)

group = membership.group
json.group do
  json.id group.id
  json.name group.name
  json.official group.official
  json.cover do
    json.main group.cover.main.url
    json.card group.cover.card.url
  end
  json.members_count group.members.count ##too expensive

  if group.last_post.present?
    json.last_post_at group.last_post.last_comment_at
  else
    json.last_post_at nil
  end
end

json.is_admin group.user_is_admin?(@current_user)

user = membership.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.name
end
json.is_friend user.is_friend_of?(@current_user)

json.permissions do
  json.(membership, :edit_group, :create_subgroup, :delete_member,
    :change_join_process, :moderate_posts, :make_admin, :admin)
end