json.(approval_request, :id, :user_id, :approver_id, :accepted)

requester = approval_request.user

json.requester do
  json.id requester.id
  json.name requester.permit_name(current_user)
  json.last_experience requester.permit_last_experience(current_user)

  if requester.permit('see-avatar', current_user)
    json.avatar requester.avatar.large.url
  else
    json.avatar requester.avatar.large.default_url
  end
end