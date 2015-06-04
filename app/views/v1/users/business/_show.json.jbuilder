json.(company, :offer, :search, :business_me)

json.company do
  json.name company.company.name
  json.logo company.company.logo
end
