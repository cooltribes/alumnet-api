json.(@user, :id, :name, :email, :unread_messages_count)

json.status @user.get_status_info

json.avatar do
  json.original @user.avatar.url
  json.small @user.avatar.small.url
  json.medium @user.avatar.medium.url
  json.large @user.avatar.large.url
  json.extralarge @user.avatar.extralarge.url
end

json.groups do
  json.array! @user.groups.pluck(:id)
end

json.is_alumnet_admin @user.is_alumnet_admin?
json.is_system_admin @user.is_system_admin?