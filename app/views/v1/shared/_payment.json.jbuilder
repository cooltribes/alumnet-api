json.(payment, :id)

json.payment do
  json.id payment.id
  json.paymentable_id payment.paymentable_id
  json.paymentable_type payment.paymentable_type
  json.subtotal payment.subtotal
  json.iva payment.iva
  json.total payment.total
  json.reference payment.reference
  json.created_at payment.created_at
  json.updated_at payment.updated_at
  json.status payment.status
  json.country_id payment.country_id
  json.city_id payment.city_id
  json.address payment.address
end

user = payment.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end

paymentable = payment.paymentable
json.paymentable do
  json.id paymentable.id
  json.sku paymentable.sku
  json.name paymentable.name
  json.description paymentable.description
  json.price paymentable.price
  json.quantity paymentable.name
  json.feature paymentable.feature
end