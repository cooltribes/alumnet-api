json.data do
  json.array! @events, partial: 'mobile/shared/event', as: :event, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @events