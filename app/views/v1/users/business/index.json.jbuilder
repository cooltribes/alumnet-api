json.data do
  json.array! @companies, partial: 'v1/shared/business', as: :business, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @companies