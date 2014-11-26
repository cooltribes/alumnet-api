json.(membership, :id, :approved, :mode)

json.group do
  json.id membership.group.id
  json.name membership.group.name
  json.cover do
    json.main membership.group.cover.main.url
    json.card membership.group.cover.card.url
  end
end

json.user do
  json.id membership.user.id
  json.name membership.user.name
  json.avatar membership.user.avatar.small.url
end
