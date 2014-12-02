json.(group, :id, :name, :description, :official, :created_at)

json.country group.get_country_info

json.city group.get_city_info

json.group_type group.get_group_type_info

if group.last_post.present?
  json.last_post_at group.last_post.last_comment_at
else
  json.last_post_at nil
end

json.cover do
  json.main group.cover.main.url
  json.card group.cover.card.url
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
  json.is_admin current_user.is_admin_of_group?(group)
  json.membership_status membership.status
  json.permissions do
    json.can_moderate_members membership.try(:moderate_members)
    json.can_edit_information membership.try(:edit_information)
    json.can_create_subgroups membership.try(:create_subgroups)
    json.can_change_member_type membership.try(:change_member_type)
    json.can_approve_register membership.try(:approve_register)
    json.can_invite_users membership.try(:invite_users)
    json.can_make_group_official membership.try(:make_group_official)
  end
else
  json.is_admin false
  json.membership_status "none"
  json.permissions nil
end