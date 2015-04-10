json.array! @contacts do |user|
  json.(user, :id)

  json.name user.permit_name(@current_user)
  json.email user.permit_email(@current_user)

  json.last_experience user.permit_last_experience(@current_user)


  json.avatar do
    if user.permit('see-avatar', @current_user)
      json.large user.avatar.large.url
    else
      json.large user.avatar.large.default_url
    end
  end

  attendance = user.attendance_for(@event)
  if attendance
    json.attendance_info attendance, :id, :status, :event_id, :user_id, :created_at
  else
    json.attendance_info nil
  end
end
