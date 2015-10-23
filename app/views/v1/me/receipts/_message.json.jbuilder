message = receipt.message
json.id receipt.id
json.subject message.subject
json.body message.body
json.created_at message.created_at
json.conversation_id receipt.conversation.id
json.is_read receipt.is_read

sender = message.sender
json.sender do
  if sender
    json.id message.sender.id
    json.name message.sender.name
    json.avatar do
      if sender.permit('see-avatar', current_user)
        json.medium sender.avatar.medium.url
        json.large sender.avatar.large.url
      else
        json.medium sender.avatar.medium.default_url
        json.large sender.avatar.large.default_url
      end
    end
  else
    json.null!
  end
end