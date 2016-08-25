json.data do
  json.array! @friends, partial: 'mobile/shared/friend', as: :user, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @friends