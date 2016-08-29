json.(payment, :id, :subtotal, :iva, :total, :reference, :country_id, :city_id, :address, :status, :created_at, :updated_at)

user = payment.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
  json.location user.location
end

json.paymentable payment.paymentable

json.country do
	json.id payment.country_id
	json.name payment.get_country_name
end