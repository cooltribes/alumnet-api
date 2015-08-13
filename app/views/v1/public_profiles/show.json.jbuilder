json.(@user, :id, :member)
json.name @user.permit_name(@current_user)
json.email @user.permit_email(@current_user)
json.last_experience @user.permit_last_experience(@current_user)

# Avatar
if @user.permit('see-avatar', @current_user)
  json.avatar @user.avatar.extralarge.url
else 
  json.avatar @user.avatar.default_url
end

#Date
bornDate = @user.profile.permit_born(@current_user)
array = []
array.push(bornDate[:year]) if bornDate[:year]
array.push(bornDate[:month]) if bornDate[:month]
array.push(bornDate[:day]) if bornDate[:day]
completeDate = array.join("/")

#Location of origin
city = @user.profile.permit_birth_city(@current_user)
completeLocation = nil
if city
  country = @user.profile.permit_birth_country(@current_user)
  completeLocation = "#{city[:text]} - #{country[:text]}"
end

#Born (date and location)
array = []
array.push(completeLocation) if completeLocation
array.push(completeDate) if completeDate != ""
completeBorn = array.join(" in ")

json.born completeBorn


#Location of residence
city = @user.profile.permit_residence_city(@current_user)
completeLocation = nil
if city
  country = @user.profile.permit_residence_country(@current_user)
  completeLocation = "#{city[:text]} - #{country[:text]}"
end

json.residence completeLocation


#Languages and Skills
json.languages @user.profile.languages, :name
json.skills @user.profile.skills, :name


#Experiences
json.experiences @user.profile.experiences do |experience|
  if experience.permit @current_user
    json.(experience, :id, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
      :internship, :aiesec_experience, :profile_id, :privacy)

    json.region experience.get_info_region
    json.country experience.get_info_country
    json.city experience.get_info_city
  end
end
