module Alumnet
  module Amigable
    extend ActiveSupport::Concern

    included do
      has_many :friendships, dependent: :destroy
      has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
      has_many :friends, through: :friendships
      has_many :inverse_friends, through: :inverse_friendships, source: :user
    end

    ### all about friends and friendships

    def create_friendship_for(user)
      friendships.build(friend_id: user.id)
    end

    def friendship_with(user)
      Friendship.where("(friend_id = :id and user_id = :user_id) or (friend_id = :user_id and user_id = :id)", id: id, user_id: user.id).first
      # friendships.find_by(friend_id: user.id) || inverse_friendships.find_by(user_id: user.id)
    end

    def friendship_status_with(user)
      ##Optimize this
      if is_friend_of?(user) || id == user.id
        "accepted"
      elsif pending_friendship_with(user).present?
        "sent"
      elsif pending_inverse_friendship_with(user).present?
        "received"
      else
        "none"
      end
    end

    def is_friend_of?(user)
      accepted_friendship_with(user).present? || accepted_inverse_friendship_with(user).present?
    end

    def get_pending_friendships(filter, query = nil)
      if filter == "sent"
        search_pending_friendship(query)
      elsif filter == "received"
        search_pending_inverse_friendships(query)
      else
        search_pending_friendship(query) | search_pending_inverse_friendships(query)
      end
    end

    def search_accepted_friendships(q)
      accepted_friendships_search = accepted_friendships.ransack(q)
      accepted_inverse_friendships_search = accepted_inverse_friendships.ransack(q)
      accepted_friendships_search.result | accepted_inverse_friendships_search.result
    end

    def search_accepted_friends(q)
      accepted_friends_search = accepted_friends.ransack(q)
      accepted_inverse_friends_search = accepted_inverse_friends.ransack(q)
      accepted_friends_search.result | accepted_inverse_friends_search.result
    end

    def search_pending_friendship(query)
      pending_friendships.ransack(query).result.to_a
    end

    def search_pending_inverse_friendships(query)
      pending_inverse_friendships.ransack(query).result.to_a
    end

    def my_friends
      accepted_friends | accepted_inverse_friends
    end

    def pending_friendship_with(user)
      pending_friendships.find_by(friend_id: user.id)
    end

    def pending_inverse_friendship_with(user)
      pending_inverse_friendships.find_by(user_id: user.id)
    end

    def accepted_friendship_with(user)
      accepted_friendships.find_by(friend_id: user.id)
    end

    def accepted_inverse_friendship_with(user)
      accepted_inverse_friendships.find_by(user_id: user.id)
    end

    def accepted_friends
      friends.where("friendships.accepted = ?", true).where(status: 1)
    end

    def accepted_inverse_friends
      inverse_friends.where("friendships.accepted = ?", true).where(status: 1)
    end

    def accepted_friendships
      friendships.where(accepted: true)
    end

    def accepted_inverse_friendships
      inverse_friendships.where(accepted: true)
    end

    def pending_friendships
      friendships.where(accepted: false)
    end

    def pending_inverse_friendships
      inverse_friendships.where(accepted: false)
    end

    def common_friends_with(user)
      my_friends & user.my_friends
    end

    ### Counts
    def friends_count
      my_friends.count
    end

    def pending_received_friendships_count
      pending_inverse_friendships.count
    end

    def pending_sent_friendships_count
      pending_friendships.count
    end

    def pending_approval_requests_count
      get_pending_approval_requests.count
    end

    def approved_requests_count
      get_approved_requests.count
    end

    def mutual_friends_count(user)
      common_friends_with(user).count
    end

  end
end