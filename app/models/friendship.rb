class Friendship < ActiveRecord::Base
  ###relations
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :existence_of_friendship

  ###Instance Methods

  def accept!
    toggle(:accepted)
  end

  private
    def existence_of_friendship
      if Friendship.exists?(user_id: self.user_id, friend_id: self.friend_id) ||
        Friendship.exists?(user_id: self.friend_id, friend_id: self.user_id)
        errors.add(:friend_id, "the user is your friend already")
      end
    end
end
