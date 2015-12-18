puts "Generating Users Login List ..."
File.open("users_login_list.csv", "w") do |file|
  file.write "ID,Name,Joined,Last login,Login count,Register Step\n"
  User.includes(:profile).all.each do |u|
    file.write "#{u.id},#{u.name},#{u.created_at.strftime('%d-%m-%Y')},#{u.last_sign_in_at},#{u.sign_in_count},#{u.profile.register_step}  \n"
  end
end
puts "Users List done!"