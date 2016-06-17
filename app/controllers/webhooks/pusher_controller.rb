class Webhooks::PusherController < ActionController::API

  def create
    webhook = Pusher::WebHook.new(request)
    if webhook.valid?
      webhook.events.each do |event|
        case event["name"]
        when 'channel_occupied'
          channel = event["channel"]
          id = channel.split("-").last.to_id
          PusherOnlineJob.perform_later(id, true)
        when 'channel_vacated'
          channel = event["channel"]
          id = channel.split("-").last.to_id
          PusherOnlineJob.perform_later(id, false)
        end
      end
      render text: 'ok'
    else
      render text: 'invalid', status: 401
    end
  end

end