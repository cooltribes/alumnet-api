class PusherDelegator
  class << self

    def send_message(message, recipients_collection)
      PusherMessageJob.perform_later(message, recipients_collection)
    end

    def send_notification(notification, recipients_collection)
      PusherNotificationJob.perform_later(notification.id, recipients_collection)
    end
  end
end