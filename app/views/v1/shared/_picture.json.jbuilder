json.(picture, :id, :title, :created_at, :date_taken)

json.picture do
    json.original picture.picture.url
    json.main picture.picture.main.url
    json.card picture.picture.card.url
    json.modal picture.picture.modal.url
end

json.city do
  if picture.city.present?
    json.id picture.city.id
    json.text picture.city.name
  else
    json.nil!
  end
end

json.country do
  if picture.country.present?
    json.id picture.country.id
    json.text picture.country.name
  else
    json.nil!
  end
end

json.uploader do
  if picture.uploader.present?
    json.id picture.uploader.id
    json.name picture.uploader.permit_name(current_user)
    json.avatar do
      if picture.uploader.permit('see-avatar', current_user)
        json.large picture.uploader.avatar.large.url
      else
        json.large picture.uploader.avatar.large.default_url
      end
    end
  else
    json.nil!
  end
end

json.likes_count picture.likes_count
json.you_like picture.has_like_for?(current_user)


json.can_delete picture.can_be_deleted_by(current_user)
# json.permissions do
#   json.canEdit comment.can_edited_by(current_user)
#   json.canDelete comment.can_deleted_by(current_user)
# end