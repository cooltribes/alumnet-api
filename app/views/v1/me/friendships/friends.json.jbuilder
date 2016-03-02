json.data do
  json.array! @friends, partial: 'v1/shared/user', as: :user, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @friends