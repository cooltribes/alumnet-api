json.(business, :id, :offer, :search, :business_me)

json.company do
  json.name business.company.name
  json.logo business.company.logo.main
end

json.keywords_offer do
  if business.offer_keywords.any?
    json.array! business.offer_keywords, :name       
  else
    json.array! []
  end
end

json.keywords_search do
  if business.search_keywords.any?
    json.array! business.search_keywords, :name      
  else
    json.array! []
  end
end

