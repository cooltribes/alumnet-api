class PusherOnlineJob < ActiveJob::Base
  queue_as :pusher

  def perform(id, online)
    user = User.where(id: id).first
    if user
      user.update(online: online)
      user.my_friends.each do |friend|
        bind = online ? "user_online" : "user_offline"
        Pusher["USER-#{friend.id}"].trigger(bind, { user_id: user.id })
      end
    end
  end
end