if experience.permit current_user
  json.(experience, :id, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
    :internship, :aiesec_experience, :profile_id, :privacy)

  json.region experience.get_info_region
  json.country experience.get_info_country
  json.city experience.get_info_city
  json.company experience.get_info_company
  json.seniority experience.get_info_seniority
end