json.(task, :id, :name, :description, :duration, :post_until, :must_have_list,
  :nice_have_list, :help_type, :offer)

json.country task.country_info
json.city task.city_info