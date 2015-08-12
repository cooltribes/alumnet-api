json.(@user, :id, :member)
json.name @user.permit_name(@current_user)
json.email @user.permit_email(@current_user)
json.last_experience @user.permit_last_experience(@current_user)

#Date
bornDate = @user.profile.permit_born(@current_user)
array = []
array.push(bornDate[:year]) if bornDate[:year]
array.push(bornDate[:month]) if bornDate[:month]
array.push(bornDate[:day]) if bornDate[:day]
completeDate = array.join("/")

#Location of origin
city = @user.profile.permit_birth_city(@current_user)
completeOrigin = ""
if city
  country = @user.profile.permit_birth_country(@current_user)
  completeOrigin = "#{city} - #{country}"
end

#Born
array = []
array.push(completeOrigin) if completeOrigin
array.push(completeDate) if completeDate
completeBorn = array.join(" in ")
json.born completeBorn

# if true
if @user.permit('see-avatar', @current_user)
  json.avatar @user.avatar.extralarge.url
else 
  json.avatar @user.avatar.default_url
end

json.languages @user.profile.languages, :name
json.skills @user.profile.skills, :name

# json.languages @user.profile.languages do |language|
#   language.name
# end
#   if true
#     @user.avatar.extralarge.url    
#   else
#     @user.avatar.default_url    
#   end
# end