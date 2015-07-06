json.(folder, :id, :name, :folderable_id, :folderable_type, :created_at, :updated_at)

json.creator do
  json.id folder.creator.id
  json.name folder.creator.permit_name(current_user)
  json.avatar do
    if folder.creator.permit('see-avatar', current_user)
      json.large folder.creator.avatar.large.url
    else
      json.large folder.creator.avatar.large.default_url
    end
  end
end

json.files_count folder.files_count

if folder.attachments.any?
  json.files folder.attachments, partial: 'v1/folders/attachments/attachment', as: :attachment, current_user: current_user
else
  json.files nil
end

json.user_can_edit folder.user_can_edit(current_user)


# json.files do
#   json.array! folder.attachments do |attachment|
#     json.id attachment.id
#     json.name attachment.name
#     if attachment.user_can_download(current_user)
#       json.url attachment.file.url
#     else
#       json.url nil
#     end
#     json.folder_id folder.id

#   end
# end
