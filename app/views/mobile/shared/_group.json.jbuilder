json.(group, :id, :name, :created_at)

json.members_count group.members.size

json.cover do
  json.card group.cover.card.url
end

membership = group.membership_of_user(current_user)

if group.last_post.present?
  json.last_post_at group.last_post.last_comment_at
else
  json.last_post_at nil
end

if membership
  json.membership do
    json.id membership.id
    json.admin group.user_is_admin?(current_user)
    json.membership_status membership.status
    json.membership_created membership.created_at
  end
else
  json.membership do
    json.id nil
    json.admin false
    json.membership_status "none"
    json.permissions nil
  end
end
