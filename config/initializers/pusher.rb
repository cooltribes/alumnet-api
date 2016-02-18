require 'pusher'

Pusher.url = Settings.pusher_url
Pusher.logger = Rails.logger