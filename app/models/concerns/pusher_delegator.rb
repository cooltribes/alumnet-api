class PusherDelegator
  class << self

    def notify_new_message(message, recipients_collection)
      recipients_collection.each do |recipient|
        Pusher["USER-#{recipient.id}"].trigger('new_message', message.attributes)
      end
    end

    def notifiy_new_notification(notification, recipients_collection)
      recipients_collection.each do |recipient|
        Pusher["USER-#{recipient.id}"].trigger('new_notification', notification.attributes)
      end
    end
  end
end