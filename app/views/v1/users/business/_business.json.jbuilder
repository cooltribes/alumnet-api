json.(business, :offer, :search, :business_me)

json.company do
  json.name business.company.name
  json.logo business.company.logo
end
