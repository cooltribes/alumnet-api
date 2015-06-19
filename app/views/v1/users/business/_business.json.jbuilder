json.(business, :id, :offer, :search, :business_me)

json.company do
  json.name business.company.name
  json.logo business.company.logo.main
end

json.offer_keywords do
  if business.offer_keywords.any?
    json.array! business.offer_keywords_name, :name       
  else
    json.array! []
  end
end

json.search_keywords do
  if business.search_keywords.any?
    json.array! business.search_keywords_name, :name      
  else
    json.array! []
  end
end

json.links do
  json.array! business.links do |link|
    json.id link.id
    json.title link.title    
    json.description link.description    
    json.url link.url
  end
end
