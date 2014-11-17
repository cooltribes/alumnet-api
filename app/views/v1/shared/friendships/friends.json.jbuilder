json.array! @friends do |friend|
  json.(friend, :id, :name)
  json.thumb friend.avatar.thumb.url
  json.friendship friend.friendship_with(@current_user)
end
