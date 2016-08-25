json.data do
  json.array! @users, partial: 'mobile/shared/user', as: :user, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @users