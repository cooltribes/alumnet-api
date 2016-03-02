json.data do
  json.array! @events, partial: 'v1/shared/event', as: :event, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @events
