json.array! @sectors do |sector|
  json.(sector, :id, :name)
end