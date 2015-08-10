json.(@user, :id, :name, :email, :member)
json.profile @user.profile, :id, :first_name, :last_name

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