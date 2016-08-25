json.(membership, :id, :approved, :group_id)

group = membership.group

json.group do
  json.id group.id
  json.created_at group.created_at
  json.name group.name
  json.official group.official
  json.cover do
    json.main group.cover.main.url
    json.card group.cover.card.url
  end
  json.members_count group.members.count ##too expensive

  if group.last_post.present?
    json.last_post_at group.last_post.last_comment_at
  else
    json.last_post_at nil
  end
end

