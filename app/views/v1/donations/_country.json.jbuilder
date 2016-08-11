json.(country, :id, :name, :cc_fips, :cc_iso, :aiesec)
json.region do
  json.id country.try(:region).try(:id)
  json.name country.try(:region).try(:name)
end