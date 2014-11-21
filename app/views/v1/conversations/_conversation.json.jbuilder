json.(conversation, :id, :subject, :created_at)

json.is_read conversation.is_read?(current_user)

json.last_message do
  json.partial! 'v1/conversations/message', message: conversation.last_message
end