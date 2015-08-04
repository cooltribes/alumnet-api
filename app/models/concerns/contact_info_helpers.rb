module ContactInfoHelpers

  def permit(user)
    
    return true if privacy == 2

    if contactable_type == "Profile"
      return true if contactable.user == user
      return contactable.user.is_friend_of?(user) if privacy == 1
      return (contactable.user == user) if privacy == 0    
    else
      true
    end  

  end

end
