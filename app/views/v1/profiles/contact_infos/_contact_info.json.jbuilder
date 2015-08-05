if contact_info.permit current_user
  json.(contact_info, :id, :contact_type, :info, :privacy, :contactable_id)
end