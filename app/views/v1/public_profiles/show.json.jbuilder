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

#Born (date and location)
json.born @user.profile.completeBorn (@current_user)


#Location of residence
json.residence @user.profile.residenceLocation(@current_user)


#Languages and Skills
json.languages @user.profile.languages, :name
json.skills @user.profile.skills, :name


#Experiences
json.experiences @user.profile.experiences do |experience|
  if experience.permit @current_user
    json.(experience, :id, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
      :internship, :aiesec_experience, :profile_id, :privacy)

    json.location experience.get_location
  end
end
