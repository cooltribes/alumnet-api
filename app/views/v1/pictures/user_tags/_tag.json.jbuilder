json.(tag, :id)
json.user_id tag.user_id
json.user_name tag.user.name
if tag.position
  json.posX tag.position[:posX]
  json.posY tag.position[:posY]
else
  json.posX 0
  json.posY 0
end