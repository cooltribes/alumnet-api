json.(business, :offer, :search, :business_me)

json.company do
  json.name business.company.name
  json.logo business.company.logo.main
end

json.offer_keywords do
  if business.offer_keywords.any?
    json.array! business.offer_keywords do |keyword_rel|
      json.name keyword_rel.keyword.name
    end    
  else
    json.array! []
  end
end

json.search_keywords do
  if business.search_keywords.any?
    json.array! business.search_keywords do |keyword_rel|
      json.name keyword_rel.keyword.name
    end    
  else
    json.array! []
  end
end

