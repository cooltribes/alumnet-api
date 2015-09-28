json.(user_product, :id, :start_date, :end_date, :status, :quantity, :transaction_type, :updated_at, :created_at)

json.user_product do
  json.id user_product.id
  json.status user_product.status
  json.start_date user_product.start_date
  json.end_date user_product.end_date
  json.quantity user_product.quantity
  json.transaction_type user_product.transaction_type
  json.created_at user_product.created_at
  json.updated_at user_product.updated_at
end

user = user_product.user
json.user do
  json.id user.id
  json.name user.name
  json.avatar user.avatar.large.url
  json.last_experience user.last_experience.try(:name)
end

product = user_product.product
json.product do
  json.id product.id
  json.sku product.sku
  json.name product.name
  json.description product.description
  json.price product.price
  json.status product.status
  json.product_type product.product_type
  json.quantity product.quantity
  json.feature product.feature
  json.created_at product.created_at
  json.updated_at product.updated_at
end