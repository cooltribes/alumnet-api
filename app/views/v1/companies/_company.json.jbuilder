json.(company, :id, :name, :description, :size, :main_address)

json.country company.country_info
json.city company.city_info
json.sector company.sector_info

json.branches company.branches, :address, :created_at
json.links company.links, :title, :description, :url, :created_at, :updated_at

if company.logo
  json.logo do
    json.original company.logo.url
    json.main company.logo.main.url
    json.card company.logo.card.url
  end
else
  json.logo json.nil!
end
