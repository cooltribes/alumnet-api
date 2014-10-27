json.(group, :id, :name, :description, :group_type, :official, :created_at)

json.avatar do
  json.original group.avatar.url
  json.thumb group.avatar.thumb.url
end

json.parent do
  if group.has_parent?
    json.(group.parent, :id, :name, :description, :avatar, :group_type)
  else
    json.nil!
  end
end

json.children do
  if group.has_children?
    json.array! group.children, :id, :name, :description, :avatar, :group_type
  else
    json.array! []
  end
end

json.members do
  json.array! group.users do |user|
    json.id user.id
    json.name user.name
    json.email user.email
    json.avatar user.avatar.url
  end
end

json.creator do
  if group.creator.present?
    json.(group.creator, :id, :name) #for now
  else
    json.nil!
  end
end

json.membership group.membership_of_user(user), :id, :mode, :approved,
  :moderate_members, :edit_information, :create_subgroups, :change_member_type,
  :approve_register, :make_group_official, :make_event_official