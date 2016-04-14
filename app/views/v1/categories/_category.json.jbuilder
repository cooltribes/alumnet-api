json.(category, :id, :name, :description, :status, :father_id, :created_at, :updated_at)

if category.father.present?
	json.parent do
		json.id category.father.id
		json.name category.father.name
	end
end