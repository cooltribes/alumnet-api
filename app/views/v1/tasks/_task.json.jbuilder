json.(task, :id, :name, :description, :duration, :post_until, :must_have_list,
  :nice_have_list, :help_type, :offer, :created_at)

json.country task.country_info
json.city task.city_info
json.company task.company_info
json.employment task.employment_info
json.position task.position_info

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

json.applied_count task.matches.applied.count

if task.matches.applied.any?
  json.applied task.matches.applied, partial: 'v1/shared/match', as: :match, current_user: current_user
else
  json.applied nil
end

json.matches_count task.matches.count

if task.matches.any?
  json.matches task.matches, partial: 'v1/shared/match', as: :match, current_user: current_user
else
  json.matches nil
end

if task.task_attributes.nice_have.any?
  json.nice_have_attributes task.task_attributes.nice_have, :id, :value, :profinda_id, :custom_field
else
  json.nice_have_attributes nil
end

if task.task_attributes.must_have.any?
  json.must_have_attributes task.task_attributes.must_have, :id, :value, :profinda_id, :custom_field
else
  json.must_have_attributes nil
end

json.user_applied task.user_applied?(current_user)
json.user_can_apply task.can_apply(current_user)
