class Product < ActiveRecord::Base
	mount_uploader :image, ProductUploader
	enum status: [:inactive, :active]
	enum highlight: [:no, :yes]
	enum tax_rule: [:no_tax, :automatic]
	enum discount_type: [:no_discount, :percentage, :amount]

	# Relations
	has_many :user_products, dependent: :destroy

	### Validations
	validates_presence_of :name, :description
end
