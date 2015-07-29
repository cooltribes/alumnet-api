class Prize < ActiveRecord::Base
	mount_uploader :image, PrizeUploader
	enum status: [:inactive, :active]

	# Relations
	has_many :user_prizes, dependent: :destroy

	### Validations
	validates_presence_of :name, :description, :price
end
