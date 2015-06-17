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

