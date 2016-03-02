json.data do
  json.array! @companies, partial: 'company', as: :company, current_user: @current_user
end

json.partial! 'v1/shared/pagination', results: @results || @companies
