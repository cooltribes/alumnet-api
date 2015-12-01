class PusherNotificationJob < ActiveJob::Base
  include Rollbar::ActiveJob
  queue_as :pusher

  def perform(notification_id, recipients_collection)
    notification = Mailboxer::Notification.find_by(id: notification_id)
    recipients_collection.each do |recipient|
      Pusher["USER-#{recipient.id}"].trigger('new_notification', notification.try(:attributes))
    end
  end
end