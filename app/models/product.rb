class Product < ActiveRecord::Base
	enum status: [:inactive, :active]

	# Relations
	#has_many :user_product, dependent: :destroy

	### Validations
	validates_presence_of :name, :description, :price
end
