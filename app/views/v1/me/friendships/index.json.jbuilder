json.data do
  json.array! @friendships, partial: 'v1/shared/friendship', as: :friendship, current_user: @user
end

json.partial! 'v1/shared/pagination', results: @results || @friendships