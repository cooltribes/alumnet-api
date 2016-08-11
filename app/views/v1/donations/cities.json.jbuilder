json.array! @cities do |city|
  json.(city, :id, :name, :cc_iso)
end