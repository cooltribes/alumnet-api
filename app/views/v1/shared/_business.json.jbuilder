json.(business, :id, :offer, :search, :business_me, :tagline)

user = business.profile.user

json.company do
  json.id business.company.id
  json.name business.company.name
  json.logo business.company.logo.url
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

json.user do
  json.(user, :id)
  json.name user.permit_name(current_user)
  json.last_experience user.permit_last_experience(current_user)
  if user.permit('see-avatar', current_user)
    json.avatar user.avatar.large.url
  else
    json.avatar user.avatar.large.default_url
  end
end
