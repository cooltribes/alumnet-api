class PusherNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(notification, recipients_collection)
    recipients_collection.each do |recipient|
      Pusher["USER-#{recipient.id}"].trigger('new_notification', notification.attributes)
    end
  end
end