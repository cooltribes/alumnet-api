json.array! @committees do |committee|
  json.(committee, :id, :name, :cc_fips)
end