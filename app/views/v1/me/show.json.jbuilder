json.(@user, :id, :name, :member, :email, :unread_messages_count, :unread_notifications_count,
  :remaining_job_posts, :show_onboarding)

json.profinda_api_token @user.profinda_api_token
json.status @user.get_status_info

json.avatar do
  json.original @user.avatar.url
  json.small @user.avatar.small.url
  json.medium @user.avatar.medium.url
  json.large @user.avatar.large.url
  json.extralarge @user.avatar.extralarge.url
end

json.cover do
  json.original @user.cover.url
  json.main @user.cover.main.url
end

json.groups do
  json.array! @user.groups.pluck(:id)
end

json.is_admin @user.is_admin?
json.is_regional_admin @user.is_regional_admin?
json.is_nacional_admin @user.is_nacional_admin?
json.is_alumnet_admin @user.is_alumnet_admin?
json.is_system_admin @user.is_system_admin?

json.is_premium @user.is_premium?

#Counters
json.sign_in_count @user.sign_in_count
json.friends_count @user.friends_count
json.pending_received_friendships_count @user.pending_received_friendships_count
json.pending_sent_friendships_count @user.pending_sent_friendships_count
json.pending_approval_requests_count @user.pending_approval_requests_count
json.approved_requests_count @user.approved_requests_count
json.days_membership @user.days_membership

#Admin location

if @user.is_regional_admin?
  json.admin_country_id @user.profile.residence_country.id #Temp - it can change
  json.admin_country_name @user.profile.residence_country.name

  json.admin_region_id @user.admin_location.id
  json.admin_region_name @user.admin_location.name
end

if @user.is_nacional_admin?
  json.admin_country_id @user.admin_location.id
  json.admin_country_name @user.admin_location.name

  if @user.admin_location.region.present?
    json.admin_region_id @user.admin_location.region.id
    json.admin_region_name @user.admin_location.region.name
  end
end
