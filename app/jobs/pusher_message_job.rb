class PusherMessageJob < ActiveJob::Base
  include Rollbar::ActiveJob
  queue_as :pusher

  def perform(message, recipients_collection)
    recipients_collection.each do |recipient|
      Pusher["USER-#{recipient.id}"].trigger('new_message', message.attributes)
    end
  end
end