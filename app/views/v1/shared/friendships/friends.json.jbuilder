json.array! @friends do |friend|
  json.(friend, :id, :name)
  json.avatar friend.avatar.small.url
  json.friendship friend.friendship_with(@current_user)
end
