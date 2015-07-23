json.(attachment, :id, :name, :folder_id, :created_at, :updated_at)

if attachment.user_can_download(current_user)
  json.url attachment.file.url
else
  json.url nil
end

json.uploader do
  json.id attachment.uploader.id
  json.name attachment.uploader.permit_name(current_user)
  json.avatar do
    if attachment.uploader.permit('see-avatar', current_user)
      json.large attachment.uploader.avatar.large.url
    else
      json.large attachment.uploader.avatar.large.default_url
    end
  end
end

json.user_can_edit attachment.user_can_edit(current_user)

