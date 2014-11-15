json.(membership, :id, :approved, :mode)

json.group do
  json.id membership.group.id
  json.name membership.group.name
  json.cover do
    json.original membership.group.cover.url
    json.thumb membership.group.cover.thumb.url
  end
end

json.user do
  json.id membership.user.id
  json.name membership.user.name
  json.avatar do
    json.original membership.user.avatar.url
    json.thumb membership.user.avatar.thumb.url
  end
end