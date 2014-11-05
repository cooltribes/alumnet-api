json.user do
  json.name @user.name
  json.email @user.email
end

json.profile do
  json.first_name @profile.first_name
  json.last_name @profile.last_name
  json.born @profile.born
  json.register_step @profile.register_step
end