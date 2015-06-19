json.(company, :id, :name)

json.logo do
  if company.logo
    json.original company.logo.url
    json.card company.logo.card.url
    json.main company.logo.main.url
  else
    json.nil!
  end
end
