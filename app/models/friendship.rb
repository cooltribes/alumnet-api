class Friendship < ActiveRecord::Base
  ###relations
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :existence_of_friendship, on: :create

  ###Instance Methods

  def accept!
    unless accepted?
      update_column(:accepted, true)
      touch(:accepted_at)
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
