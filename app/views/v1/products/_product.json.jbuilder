json.(product, :id, :sku, :name, :description, :status, :price, :highlight, :category_id, :created_at, :updated_at)

if product.category.present?
	json.category do
		json.id product.category.id
		json.name product.category.name
	end
end