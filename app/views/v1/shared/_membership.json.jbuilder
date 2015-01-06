json.(membership, :id, :approved, :group_id, :user_id)

json.group do
  json.id membership.group.id
  json.name membership.group.name
  json.cover do
    json.main membership.group.cover.main.url
    json.card membership.group.cover.card.url
  end
  json.is_admin membership.group.user_is_admin?(@current_user)
end

json.user do
  json.id membership.user.id
  json.name membership.user.name
  json.avatar membership.user.avatar.large.url
  json.is_friend membership.user.is_friend_of?(@current_user)
end

json.permissions do
  json.(membership, :edit_group, :create_subgroup, :delete_member,
    :change_join_process, :moderate_posts, :make_admin)
end