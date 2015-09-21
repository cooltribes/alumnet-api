if experience.permit current_user
  json.(experience, :id, :exp_type, :name, :description, :start_date, :end_date, :organization_name,
    :internship, :aiesec_experience, :profile_id, :privacy)

  json.region experience.region_info
  json.country experience.country_info
  json.city experience.city_info
  json.company experience.company_info
  json.seniority experience.seniority_info
  json.committee_id experience.try(:committee).try(:id)
end