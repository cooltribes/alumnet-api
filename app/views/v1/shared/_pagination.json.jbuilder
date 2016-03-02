json.pagination do
  json.current_page results.try(:current_page)
  json.prev_page results.try(:prev_page)
  json.next_page results.try(:next_page)
  json.total_pages results.try(:total_pages)
  json.total_count results.try(:total_count)
end