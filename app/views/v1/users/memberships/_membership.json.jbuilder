json.(membership, :id, :approved, :mode)

group = membership.group
user = membership.user

json.is_admin user.is_admin_of_group?(group)

json.group do
  json.id group.id
  json.name group.name
  json.description group.description
  json.cover do
    json.main group.cover.main.url
    json.card group.cover.card.url
  end
end

json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.small.url
end

json.permissions do
  json.can_moderate_members membership.try(:moderate_members)
  json.can_edit_information membership.try(:edit_information)
  json.can_create_subgroups membership.try(:create_subgroups)
  json.can_change_member_type membership.try(:change_member_type)
  json.can_approve_register membership.try(:approve_register)
  json.can_invite_users membership.try(:invite_users)
  json.can_make_group_official membership.try(:make_group_official)
end