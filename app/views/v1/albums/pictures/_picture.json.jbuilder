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
    # json.id nil
    # json.text nil
    nil
  end      
end

json.country do
  if picture.country.present? 
    json.id picture.country.id
    json.text picture.country.name
  else
    # json.id nil
    # json.text nil
    nil
  end
end


# json.otra picture.picture
# json.user do
#   json.(comment.user, :id, :email)
#   json.name comment.user.permit_name(current_user)
#   if comment.user.permit('see-avatar', current_user)
#     json.avatar comment.user.avatar.medium.url
#   else
#     json.avatar comment.user.avatar.medium.default_url
#   end
# end

# json.likes_count comment.likes_count
# json.you_like comment.has_like_for?(current_user)

# json.permissions do
#   json.canEdit comment.can_edited_by(current_user)
#   json.canDelete comment.can_deleted_by(current_user)
# end