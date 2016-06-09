json.(user_product, :id, :start_date, :end_date, :status, :quantity, :transaction_type, :updated_at, :created_at)

json.user user_product.user
json.product user_product.product