json.users_all @counters["users_all"]
json.users @counters["users"]
json.members @counters["members"]
json.lt_members @counters["lt_members"]

json.query_counters do
  
  if @query_counters
    json.users_all @query_counters["users_all"]
    json.users @query_counters["users"]
    json.members @query_counters["members"]
    json.lt_members @query_counters["lt_members"]
  else
    json.nil!
  end
end
