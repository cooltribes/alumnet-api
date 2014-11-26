json.(conversation, :id, :subject, :created_at)

json.is_read conversation.is_read?(current_user)

originator = conversation.originator
json.originator do
  json.id originator.id
  json.name originator.name
  json.avatar originator.avatar.small.url
end

json.participants do
  json.array! conversation.participants do |participant|
    json.id participant.id
    json.name participant.name
  end
end

json.unread_messages_count conversation.receipts_for(current_user).is_unread.count