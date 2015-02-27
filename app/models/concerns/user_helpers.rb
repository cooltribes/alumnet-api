module UserHelpers

  def permit_name(user)
    if permit('see-name', user)
      "#{self.profile.first_name} #{self.profile.last_name}"
    else
      "#{self.profile.first_name} #{self.profile.hidden_last_name}"
    end
  end

  def permit_friends_count(user)
    permit('see-friends', user) ? self.friends_count : 0
  end

  def permit_last_experience(user)
    if self.last_experience.present? && self.permit('see-job', user)
      self.last_experience.name
    else
      nil
    end
  end
end
