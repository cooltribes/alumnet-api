json.array! @friends do |friend|
  json.id friend.id
  json.name friend.permit_name(current_user)
  json.avatar do
	  if friend.permit('see-avatar', current_user)
	    json.large friend.avatar.large.url
	  else
	    json.large friend.avatar.large.default_url
	  end
	end
end