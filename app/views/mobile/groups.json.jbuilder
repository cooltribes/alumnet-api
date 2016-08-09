json.data do
  json.array! @groups, partial: 'mobile/shared/group', as: :group, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @groups