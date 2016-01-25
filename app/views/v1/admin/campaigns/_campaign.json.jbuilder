json.(campaign, :id, :subject, :body, :status, :provider_id, :list_id, :segment_id, :created_at, :updated_at)

group = campaign.group
json.group do
  json.id group.id
  json.name group.name
  json.updated_at group.updated_at
  json.description group.description
  json.short_description group.short_description
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

  if group.first_post.present?
    json.first_post_at group.first_post.last_comment_at
  else
    json.first_post_at nil
  end
end

user = campaign.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
  json.first_committee user.first_committee
end

json.details campaign.get_mailchimp_details