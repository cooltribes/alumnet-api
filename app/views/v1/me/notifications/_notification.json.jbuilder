receipt = notification.receipt_for(current_user).first
detail = NotificationDetail.find_by(mailboxer_notification_id: notification.id)
json.(notification, :id, :body, :subject, :created_at)
json.(receipt, :is_read)

json.url detail.url
json.type detail.notification_type
json.subject_name detail.subject.name
json.subject_avatar detail.subject.avatar.large.url

