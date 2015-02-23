json.(experience, :id, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
  :internship, :aiesec_experience, :profile_id)

json.region experience.get_info_region
json.country experience.get_info_country
json.city experience.get_info_city