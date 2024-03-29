class Friendship < ActiveRecord::Base
  acts_as_paranoid

  ###relations
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :existence_of_friendship

  ###Instance Methods

  def friendship_type(user)
    if user_id == user.id
      "sent"
    elsif friend_id == user.id
      "received"
    end
  end

  def accept!(notify = true)
    unless accepted?
      update_column(:accepted, true)
      touch(:accepted_at)
      Notification.notify_accepted_friendship_to_user(user, friend) if notify
    end
  end

  private
    def existence_of_friendship
      if Friendship.exists?(user_id: self.user_id, friend_id: self.friend_id) ||
        Friendship.exists?(user_id: self.friend_id, friend_id: self.user_id)
        errors.add(:friend_id, "the user is your friend already")
      end
    end
end
