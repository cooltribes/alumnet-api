json.data do
  json.array! @memberships, partial: 'v1/shared/membership', as: :membership, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @memberships
