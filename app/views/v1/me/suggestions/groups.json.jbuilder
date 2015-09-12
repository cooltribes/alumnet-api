json.array! @groups do |group|
  json.id group.id
  json.name group.name
  json.cover group.cover.card.url
  json.members group.members.count

  membership = group.membership_of_user(@current_user)
  if membership
    json.membership_status membership.status
  else
    json.membership_status "none"
  end

end
