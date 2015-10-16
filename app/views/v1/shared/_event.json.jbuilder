json.(event, :id, :name, :description, :official, :address, :start_date, :start_hour,
  :end_date, :end_hour, :capacity, :city_id, :country_id, :created_at, :admission_type,
  :regular_price, :premium_price, :upload_files)

json.event_type event.event_type_info
json.country event.country_info
json.city event.city_info

json.cover do
  json.original event.cover.url
  json.main event.cover.main.url
  json.card event.cover.card.url
  json.position event.cover_position
end

json.creator do
  json.id event.creator.id
  json.name event.creator.permit_name(current_user)
  if event.creator.permit('see-avatar', current_user)
    json.avatar event.creator.avatar.large.url
  else
    json.avatar event.creator.avatar.large.default_url
  end
end

json.attendances_count event.attendances.count
json.going_count event.attendances.going.count
json.maybe_count event.attendances.maybe.count
json.not_going_count event.attendances.not_going.count

attendance = event.attendance_for(current_user)
if attendance
  json.attendance_info attendance, :id, :status, :event_id, :user_id, :created_at
else
  json.attendance_info nil
end

payment = event.payment_for(current_user)
if payment
  json.payment_info payment, :id, :subtotal, :iva, :total, :reference, :paymentable_id, :paymentable_type, :user_id, :created_at, :updated_at
else
  json.payment_info nil
end

json.admin event.is_admin?(current_user)
json.can_attend event.can_attend?(current_user)

json.user_can_upload_files event.user_can_upload_files?(current_user)
