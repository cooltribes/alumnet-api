module CommentHelpers

  def can_edited_by(user)
    return true if user == self.user
  end

  def can_deleted_by(user)
    return true if user == self.user
  end

end
