class PusherDelegator
  class << self

    def notify_new_message(message, recipients_collection)
      PusherMessageJob.perform_later(message, recipients_collection)
    end

    def notifiy_new_notification(notification, recipients_collection)
      PusherNotificationJob.perform_later(notification, recipients_collection)
    end
  end
end