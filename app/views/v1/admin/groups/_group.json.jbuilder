json.(group, :id, :name, :description, :official, :created_at, :join_process)

json.can_be_official group.can_be_official?

json.can_be_unofficial group.can_be_unofficial?

json.group_type group.group_type_info

json.country group.country_info

json.city group.city_info


if group.last_post.present?
  json.last_post_at group.last_post.last_comment_at
else
  json.last_post_at nil
end

json.cover do
  json.main group.cover.main.url
  json.card group.cover.card.url
  json.admin group.cover.admin.url
end

json.parent do
  if group.has_parent?
    json.(group.parent, :id, :name, :description, :group_type)
  else
    json.nil!
  end
end

json.children do
  if group.has_children?
    json.array! group.children, :id, :name, :description, :group_type
  else
    json.array! []
  end
end

json.creator do
  if group.creator.present?
    json.(group.creator, :id, :name) #for now
  else
    json.nil!
  end
end

json.admins do
  json.array! group.admins do |admin|
    json.id admin.id
    json.name admin.name
    json.email admin.email
    json.avatar admin.avatar.small.url
  end
end

json.members do
  json.array! group.members do |user|
    json.id user.id
    json.name user.name
    json.email user.email
    json.avatar user.avatar.small.url
  end
end

json.membership_users do
  json.array! group.memberships.pluck(:user_id)
end

membership = group.membership_of_user(current_user)

if membership
  json.admin group.user_is_admin?(current_user)
  json.membership_status membership.status
  json.permissions do
    json.(membership, :edit_group, :create_subgroup, :delete_member,
      :change_join_process, :moderate_posts, :make_admin)
  end
else
  json.admin false
  json.membership_status "none"
  json.permissions nil
end