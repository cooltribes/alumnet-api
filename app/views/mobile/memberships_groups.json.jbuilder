json.data do
  json.array! @memberships, partial: 'mobile/shared/membership_group', as: :membership, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @memberships