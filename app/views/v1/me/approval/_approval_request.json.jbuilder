json.(approval_request, :id, :user_id, :approver_id, :accepted)

requester = approval_request.user
approver = approval_request.approver

json.requester do
  json.id requester.id
  json.name requester.permit_name(current_user)
  json.last_experience requester.permit_last_experience(current_user)
  json.first_committee requester.first_committee

  if requester.permit('see-avatar', current_user)
    json.avatar requester.avatar.large.url
  else
    json.avatar requester.avatar.large.default_url
  end
end

json.approver do
  json.id approver.id
  json.name approver.permit_name(current_user)
  json.last_experience approver.permit_last_experience(current_user)
  json.first_committee approver.first_committee

  if approver.permit('see-avatar', current_user)
    json.avatar approver.avatar.large.url
  else
    json.avatar approver.avatar.large.default_url
  end
end