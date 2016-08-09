json.(group, :id, :name, :created_at)

json.members_count group.members.size

json.cover do
  json.card group.cover.card.url
end

membership = group.membership_of_user(current_user)

if membership
  json.membership do
    json.id membership.id
    json.admin group.user_is_admin?(current_user)
    json.membership_status membership.status
    json.membership_created membership.created_at
    json.permissions do
      json.(membership, :edit_group, :create_subgroup, :delete_member,
        :change_join_process, :moderate_posts, :make_admin)
    end
  end
else
  json.membership do
    json.id nil
    json.admin false
    json.membership_status "none"
    json.permissions nil
  end
end
