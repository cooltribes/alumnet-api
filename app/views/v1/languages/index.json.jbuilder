json.array! @languages do |language|
  json.(language, :id, :name)
end