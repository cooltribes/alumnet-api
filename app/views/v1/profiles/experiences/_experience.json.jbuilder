json.(experience, :id, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
  :internship, :profile_id)

if experience.city.present?
  json.city do
    json.id experience.city.id
    json.text experience.city.name
  end
else
  json.city nil
end

if experience.country.present?
  json.country do
    json.id experience.country.id
    json.text experience.country.name
  end
else
  json.country nil
end
