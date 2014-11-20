json.subject message.subject
json.body message.body
json.sender do
  json.id message.sender.id
  json.name message.sender.name
  json.thumb message.sender.avatar.thumb.url
end