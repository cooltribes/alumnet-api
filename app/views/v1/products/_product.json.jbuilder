json.(product, :id, :sku, :name, :description, :status, :highlight, :created_at, :updated_at, :image, :sale_price, :tax_rule, :tax_value, 
	:discount_type, :discount_value, :total_price)

json.product_characteristics product.product_characteristics
json.characteristics product.characteristics
json.product_categories product.product_categories
json.categories product.categories