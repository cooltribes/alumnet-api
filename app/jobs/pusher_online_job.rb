class PusherOnlineJob < ActiveJob::Base
  queue_as :pusher

  def perform(id, online)
    user = User.where(id: id).first
    if user
      user.update(online: online)
      user.my_friends.each do |friend|
        Pusher["USER-#{friend.id}"].trigger("user_online", { user_id: user.id, online: online })
      end
    end
  end
end