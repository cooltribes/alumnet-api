json.(company, :id, :name)

if company.logo
  json.logo company.logo.url
else
  json.logo json.nil!
end