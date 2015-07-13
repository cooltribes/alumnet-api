puts "Generating User Info file..."
File.open("user_geo_info.csv", "w") do |file|
  file.write "id,name,residence_city,residence_city_id,residence_country,residence_country_id,birth_city,birth_city_id,birth_country,birth_country_id\n"
  User.all.each do |u|
    p = u.profile
    file.write "#{u.id},#{u.try(:name)},#{p.residence_city.try(:name)},#{p.residence_city_id},#{p.residence_country.try(:name)},#{p.residence_country_id},#{p.birth_city.try(:name)},#{p.birth_city_id},#{p.birth_country.try(:name)},#{p.birth_country_id}\n"
  end
end
puts "Users done!"

puts "Generating Experiences Info file..."
File.open("experience_geo_info.csv", "w") do |file|
  file.write "id,user_name,experience_name,experience_id,country,country_id,city,city_id\n"
  User.all.each do |u|
    p = u.profile
    p.experiences.each do |e|
      file.write "#{u.id},#{u.name},#{e.name},#{e.id},#{e.country.try(:name)},#{e.country_id},#{e.city.try(:name)},#{e.city_id}\n"
    end
  end
end
puts "Experiences done!"

puts "Generating Group Info file..."
File.open("group_geo_info.csv", "w") do |file|
  file.write "id,group,country,country_id,city,city_id\n"
  Group.all.each do |g|
    file.write "#{g.id},#{g.name},#{g.country.try(:name)},#{g.country_id},#{g.city.try(:name)},#{g.city_id}\n"
  end
end
puts "Group done!"

puts "Generating Event Info file..."
File.open("event_geo_info.csv", "w") do |file|
  file.write "id,event,country,country_id,city,city_id\n"
  Event.all.each do |e|
    file.write "#{e.id},#{e.name},#{e.country.try(:name)},#{e.country_id},#{e.city.try(:name)},#{e.city_id}\n"
  end
end
puts "Event done!"

puts "Generating Task Info file..."
File.open("task_geo_info.csv", "w") do |file|
  file.write "id,task,country,country_id,city,city_id\n"
  Task.all.each do |t|
    file.write "#{t.id},#{t.name},#{t.country.try(:name)},#{t.country_id},#{t.city.try(:name)},#{t.city_id}\n"
  end
end
puts "Task done!"