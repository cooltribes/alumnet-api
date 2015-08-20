json.array! @groups do |group|
  json.id group.id
  json.name group.name

  membership = group.membership_of_user(@user)
  json.is_admin membership.admin
  json.approved_at membership.approved_at
end