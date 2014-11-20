json.(conversation, :id, :subject, :created_at)

json.is_read conversation.is_read?(current_user)

receipts = conversation.receipts_for(current_user)

json.messages do
  json.array! receipts do |receipt|
    message = receipt.message
    json.subject message.subject
    json.body message.body
    json.sender do
      json.id message.sender.id
      json.name message.sender.name
      json.thumb message.sender.avatar.thumb.url
    end
  end
end