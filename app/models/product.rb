class Product < ActiveRecord::Base
	enum status: [:inactive, :active]

	# Relations
	has_many :user_products, dependent: :destroy
	belongs_to :user
	belongs_to :category

	### Validations
	validates_presence_of :name, :description, :price
end
