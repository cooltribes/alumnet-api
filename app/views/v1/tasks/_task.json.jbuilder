json.(task, :id, :name, :description, :duration, :post_until, :must_have_list,
  :nice_have_list, :help_type, :offer, :created_at)

json.country task.country_info
json.city task.city_info
json.company task.company_info

json.user do
  json.(task.user, :id)
  json.name task.user.permit_name(current_user)
  json.last_experience task.user.permit_last_experience(current_user)
  if task.user.permit('see-avatar', current_user)
    json.avatar task.user.avatar.large.url
  else
    json.avatar task.user.avatar.large.default_url
  end
end