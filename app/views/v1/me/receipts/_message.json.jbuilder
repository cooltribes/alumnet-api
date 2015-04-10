message = receipt.message
json.id receipt.id
json.subject message.subject
json.body message.body
json.created_at message.created_at
json.conversation_id receipt.conversation.id
json.is_read receipt.is_read
json.sender do
  json.id message.sender.id
  json.name message.sender.name
  json.avatar message.sender.avatar.large.url
end