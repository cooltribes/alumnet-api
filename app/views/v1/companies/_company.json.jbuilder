json.(company, :id, :name, :description, :size, :main_address, :is_free)

json.country company.country_info
json.city company.city_info
json.sector company.sector_info
json.size company.size_info

json.branches company.branches, partial: 'v1/companies/branches/branch', as: :branch, current_user: current_user
json.products_services company.product_services, partial: 'v1/companies/product_services/product_service', as: :product_service, current_user: current_user
json.contacts company.contact_infos, partial: 'v1/shared/contact_info', as: :contact_info, current_user: current_user
json.links company.links, :title, :description, :url, :created_at, :updated_at
json.employees company.employees, :id

if company.logo
  json.logo do
    json.original company.logo.url
    json.main company.logo.main.url
    json.card company.logo.card.url
  end
else
  json.logo json.nil!
end

if company.cover
  json.cover do
    json.original company.cover.url
    json.main company.cover.main.url
    json.card company.cover.card.url
  end
else
  json.cover json.nil!
end

json.creator do
  json.id company.creator_id
  json.name company.creator.try(:name)
end

json.employees_count company.employees.count
json.past_employees_count company.past_employees.count
json.admins_count company.accepted_admins.count

json.is_admin company.is_admin?(current_user)
json.has_request_for_admin company.has_request_for_admin(current_user)