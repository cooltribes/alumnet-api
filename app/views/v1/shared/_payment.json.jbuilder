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
  json.status paymentable.status
  json.highlight paymentable.highlight
  json.image paymentable.image
  json.sale_price paymentable.sale_price
  json.tax_rule paymentable.tax_rule
  json.tax_value paymentable.tax_value
  json.discount_type paymentable.discount_type
  json.discount_value paymentable.discount_value
  json.total_price paymentable.total_price
end