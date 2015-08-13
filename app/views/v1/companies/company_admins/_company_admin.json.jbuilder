json.(company_admin, :id, :user_id, :company_id, :status, :accepted_by, :created_at, :updated_at)
user = company_admin.user
json.user do
  json.(user, :id, :member)
  json.name user.permit_name(current_user)
  json.email user.permit_email(current_user)
  json.last_experience user.permit_last_experience(current_user)

  json.avatar do
    if user.permit('see-avatar', current_user)
      json.original user.avatar.url
      json.small user.avatar.small.url
      json.medium user.avatar.medium.url
      json.large user.avatar.large.url
      json.extralarge user.avatar.extralarge.url
    else
      json.original user.avatar.default_url
      json.small user.avatar.small.default_url
      json.medium user.avatar.medium.default_url
      json.large user.avatar.large.default_url
      json.extralarge user.avatar.extralarge.default_url
    end
  end
end