if contact_info.permit current_user
  json.(contact_info, :id, :contact_type, :info, :privacy, :contactable_id, :contactable_type)
  json.contact_type_text contact_info.contact_type_text
end