json.array! @members do |member|
  json.(member, :id, :name, :avatar)
  json.membership @group.membership_of_user(member)
end