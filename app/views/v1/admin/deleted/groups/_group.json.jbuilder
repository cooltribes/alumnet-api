json.(group, :id, :name, :description, :official, :created_at, :deleted_at, :join_process)

json.group_type group.group_type_info

json.country group.country_info

json.city group.city_info

json.cover do
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