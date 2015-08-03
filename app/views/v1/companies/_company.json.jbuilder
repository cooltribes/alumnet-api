json.(company, :id, :name, :description, :size, :main_address)

json.country company.country_info
json.city company.city_info
json.sector company.sector_info



if company.logo
  json.original company.logo.url
  json.main company.logo.main.url
  json.card company.logo.card.url
else
  json.logo json.nil!
end
