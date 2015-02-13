json.array! @skills do |skill|
  json.(skill, :id, :name)
end