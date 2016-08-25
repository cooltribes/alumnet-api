json.(payment, :id, :subtotal, :iva, :total, :reference, :country_id, :city_id, :address, :status, :created_at, :updated_at)

user = payment.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end

json.paymentable payment.paymentable