json.(@user, :unread_messages_count, :unread_notifications_count, :unread_friendship_notifications_count)

#Counters

json.friends_count @user.friends_count
json.pending_received_friendships_count @user.pending_received_friendships_count
json.pending_sent_friendships_count @user.pending_sent_friendships_count
json.pending_approval_requests_count @user.pending_approval_requests_count
json.approved_requests_count @user.approved_requests_count
json.status @user.get_status_info
json.avatar do
  json.original @user.avatar.url
  json.small @user.avatar.small.url
  json.medium @user.avatar.medium.url
  json.large @user.avatar.large.url
  json.extralarge @user.avatar.extralarge.url
end