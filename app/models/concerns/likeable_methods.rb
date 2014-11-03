module LikeableMethods

  def likes_count
    self.likes.count
  end

  def add_like_by(user)
    self.likes.create(user: user)
  end

  def remove_like_of(user)
    if like = self.likes.find_by(user_id: user.id)
      like.delete
      true
    else
      false
    end
  end
end