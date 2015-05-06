json.(banner, :id, :name, :description, :official, :created_at, :join_process)


json.banner do
  json.main group.banner.main.url
  json.card group.banner.card.url
  json.admin group.banner.admin.url
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

