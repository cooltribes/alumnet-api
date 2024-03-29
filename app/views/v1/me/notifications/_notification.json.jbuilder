receipt = notification.receipt_for(current_user).first
detail = NotificationDetail.find_by(mailboxer_notification_id: notification.id)
json.(notification, :id, :body, :subject, :created_at)
json.(receipt, :is_read)

if detail
  json.url detail.url
  json.type detail.notification_type
  json.notified_object_id detail.notified_object_id
  json.sender_name detail.sender.try(:name)
  if detail.sender
    json.sender_avatar detail.sender.avatar.large.url
  else
    json.sender_avatar nil
  end
end
