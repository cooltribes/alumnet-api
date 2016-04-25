class Product < ActiveRecord::Base
	mount_uploader :image, ProductUploader
	enum status: [:inactive, :active]
	enum highlight: [:no, :yes]

	# Relations
	has_many :user_products, dependent: :destroy
	belongs_to :user

	### Validations
	validates_presence_of :name, :description
end
