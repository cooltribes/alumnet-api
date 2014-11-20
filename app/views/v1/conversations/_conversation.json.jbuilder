json.(conversation, :id, :subject, :created_at)

json.is_read conversation.is_read?(current_user)

json.messages do
  json.array! conversation.messages, partial: 'v1/conversations/message', as: :message
end