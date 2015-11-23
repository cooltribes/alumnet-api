class GcmDelegator
  class << self

    def send_notification(notification, recipients_collection)
      GcmNotificationJob.perform_later(parse_notification(notification), recipients_collection)
    end

    def parse_notification(notification)
      detail = NotificationDetail.find_by(mailboxer_notification_id: notification.id)
      {
        id: notification.id,
        body: notification.body,
        subject: notification.subject,
        created_at: notification.created_at.to_s,
        url: detail.try(:url),
        type: detail.try(:notification_type),
        notified_object_id: detail.try(:notified_object_id),
        sender_name: detail.try(:sender).try(:name),
        sender_avatar: detail.try(:sender).try(:avatar).try(:large).try(:url)
      }
    end
  end
end