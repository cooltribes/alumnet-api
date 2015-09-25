json.array! @friends do |friend|
  json.uid friend.id
  json.value friend.permit_name(current_user)
end

