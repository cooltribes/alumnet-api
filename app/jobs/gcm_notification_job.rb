class GcmNotificationJob < ActiveJob::Base
  include Rollbar::ActiveJob
  queue_as :default

  def perform(notification, recipients_collection)
    # the recipients are Users
    tokens = []
    recipients_collection.each do |recipient|
      tokens << recipient.devices_tokens("android")
    end
    gcm = GCM.new(Settings.google_api_key)
    options = { data: notification, collapse_key: "Alumnet notification" }
    gcm.send(tokens.flatten, options)
  end
end