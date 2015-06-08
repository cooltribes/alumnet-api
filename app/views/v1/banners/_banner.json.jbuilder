json.(banner, :id, :title, :description, :link, :created_at, :updated_at, :order)

json.picture do
  json.original banner.picture.url
  json.main banner.picture.main.url
  json.card banner.picture.card.url
  json.modal banner.picture.modal.url
end


