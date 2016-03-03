json.array! @companies do |company|
  json.(company, :id, :name, :description, :size, :main_address, :is_free)

  json.country company.country_info
  json.city company.city_info
  json.sector company.sector_info
  json.size company.size_info

  if company.logo
    json.logo do
      json.original company.logo.url
      json.main company.logo.main.url
      json.card company.logo.card.url
    end
  else
    json.logo do
      json.original company.logo.default_url
      json.main company.logo.main.default_url
      json.card company.logo.card.default_url
    end
  end

  json.creator do
    json.id company.creator_id
    json.name company.creator.try(:name)
  end

  json.current_employees_count company.current_employees.count
  json.past_employees_count company.past_employees.count
  json.admins_count company.accepted_admins.count
end