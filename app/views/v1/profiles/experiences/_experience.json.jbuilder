json.(experience, :id, :aiesec_experience, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
  :internship, :profile_id)

json.region experience.get_info_region
json.country experience.get_info_country
json.city experience.get_info_city