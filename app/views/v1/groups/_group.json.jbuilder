json.(group, :id, :name, :description, :avatar, :group_type)

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