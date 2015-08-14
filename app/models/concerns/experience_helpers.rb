module ExperienceHelpers

  def permit(user)
    return true if profile.user == user
    return true if privacy == 2
    return profile.user.is_friend_of?(user) if privacy == 1
    return (profile.user == user) if privacy == 0    
  end

  #For public profiles
  def get_location
    location = "No Location"
      
    location = "#{get_info_city[:text]} - " if city

    location += "#{get_info_country[:text]}" if country      

    return location
    
  end

end
