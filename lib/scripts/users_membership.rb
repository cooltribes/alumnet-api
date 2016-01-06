puts "Generating Users Membership List ..."
File.open("users_membership.csv", "w") do |file|
  file.write "ID,Email,Name,Origin Country,Residence Country,Membership,End Date\n"
  User.includes(:profile).where.not(member: 0).each do |u|
    product = u.user_products.find_by(status: 1)
    file.write "#{u.id},#{u.email},#{u.name},#{u.profile.birth_country.try(:name)},#{u.profile.birth_country.try(:name)},#{u.member},#{product.try(:end_date)}\n"
  end
end
puts "Users List done!"