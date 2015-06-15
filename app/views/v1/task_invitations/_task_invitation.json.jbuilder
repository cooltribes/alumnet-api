json.(task_invitation, :id, :accepted, :user_id, :task_id, :created_at)

user = task_invitation.user
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

task = task_invitation.task
json.task do
  json.(task, :id, :name, :description, :duration, :post_until, :must_have_list,
    :nice_have_list, :help_type, :offer, :created_at)
  json.country task.country_info
  json.city task.city_info
  json.company task.company_info
  json.employment task.employment_info
  json.position task.position_info
end

