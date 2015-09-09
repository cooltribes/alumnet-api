class UserProduct < ActiveRecord::Base
	###Relations
	belongs_to :user
	belongs_to :product

	### Validations
  	validates_presence_of :transaction_type, :user_id
end
