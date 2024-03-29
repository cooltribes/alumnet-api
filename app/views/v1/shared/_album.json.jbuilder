json.(album, :id, :name, :description, :date_taken)

json.city do
  if album.city.present?
    json.id album.city.id
    json.text album.city.name
  else
    # json.id nil
    # json.text nil
    nil
  end
end

json.country do
  if album.country.present?
    json.id album.country.id
    json.text album.country.name
  else
    # json.id nil
    # json.text nil
    nil
  end
end

json.pictures_count album.pictures_count

json.cover_picture do
  if album.cover_picture.present?
    json.original album.cover_picture.url
    json.main album.cover_picture.main.url
    json.card album.cover_picture.card.url
  else
    nil
  end
end

if album.creator
  json.creator do
    json.(album.creator, :id)
    json.name album.creator.permit_name(current_user)
    if album.creator.permit('see-avatar', current_user)
      json.avatar album.creator.avatar.large.url
    else
      json.avatar album.creator.avatar.large.default_url
    end
  end
else
  json.creator nil
end


