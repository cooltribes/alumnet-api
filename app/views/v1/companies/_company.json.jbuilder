json.(company, :id, :name, :description, :size, :main_address, :is_free)

json.country company.country_info
json.city company.city_info
json.sector company.sector_info
json.size company.size_info

json.branches company.branches, partial: 'v1/companies/branches/branch', as: :branch, current_user: current_user
json.products_services company.product_services, partial: 'v1/companies/product_services/product_service', as: :product_service, current_user: current_user
json.contacts company.contact_infos, partial: 'v1/shared/contact_info', as: :contact_info, current_user: current_user
json.links company.links, :title, :description, :url, :created_at, :updated_at
json.employees company.employees, :id, :first_name, :last_name

if company.logo
  json.logo do
    json.original company.logo.url
    json.main company.logo.main.url
    json.card company.logo.card.url
  end
else
  json.logo json.nil!
end
