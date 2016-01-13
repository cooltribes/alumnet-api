json.array! @groups do |group|
  json.id group.id
  json.name group.name
  json.cover group.cover.card.url
  json.members group.members.count
  json.description group.description
  json.group_type group.group_type

  json.members_avatar group.members.limit(2) do |member|
    json.id member.id
    json.name member.name
    json.avatar member.avatar.small.url
  end

  membership = group.membership_of_user(@current_user)
  if membership
    json.membership_status membership.status
  else
    json.membership_status "none"
  end

end
