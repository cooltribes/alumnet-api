class UserPrize < ActiveRecord::Base
	###Relations
	belongs_to :user
	belongs_to :prize

	### Validations
  	validates_presence_of :prize_id, :user_id, :price
end
