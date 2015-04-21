module LikeableMethods

  def self.included(base)
    base.has_many :likes, as: :likeable, dependent: :destroy
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
      like.really_destroy! ## This is beacause Like model acts as paranoid!
      true
    else
      false
    end
  end
end