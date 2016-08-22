class Product < ActiveRecord::Base
	mount_uploader :image, ProductUploader
	enum status: [:inactive, :active]
	enum highlight: [:no, :yes]
	enum tax_rule: [:no_tax, :automatic]
	enum discount_type: [:no_discount, :percentage, :amount]

	scope :active, -> { where(status: 1) }

	# Relations
	belongs_to :user
	has_many :user_products, dependent: :destroy
	has_many :product_characteristics, dependent: :destroy
  has_many :characteristics, through: :product_characteristics
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

	### Validations
	validates_presence_of :name, :description
end
