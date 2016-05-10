json.data do
  json.array! @tasks, partial: 'task', as: :task, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @tasks
