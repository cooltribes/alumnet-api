json.(conversation, :id, :subject, :created_at)

json.is_read conversation.is_read?(current_user)

originator = conversation.originator
json.originator do
  json.id originator.id
  json.name originator.name
  json.thumb originator.avatar.thumb.url
end

json.participants do
  json.array! conversation.participants do |participant|
    json.id participant.id
    json.name participant.name
  end
end