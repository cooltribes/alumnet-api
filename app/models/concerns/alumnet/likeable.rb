module Alumnet
  module Likeable
    extend ActiveSupport::Concern

    included do
      has_many :likes, as: :likeable, dependent: :destroy
    end

    def likes_count
      likes.count
    end

    def add_like_by(user)
      likes.create(user: user)
    end

    def has_like_for?(user)
      likes.exists?(user: user)
    end

    def remove_like_of(user)
      if like = likes.find_by(user_id: user.id)
        # is for acts_as_paranoid
        like.respond_to?(:really_destroy!) ? like.really_destroy! : like.destroy
        true
      else
        false
      end
    end
  end
end