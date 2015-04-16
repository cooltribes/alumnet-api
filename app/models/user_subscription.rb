class UserSubscription < ActiveRecord::Base
  ### Relations
  belongs_to :user
  belongs_to :subscription
  belongs_to :creator, class_name: "User"

  after_save :set_user_membership

  def days_left
  	(end_date - start_date).to_i/3600/24
  end

  def member_value
  	return 3 if lifetime?
  	return 2 if days_left < 30
  	return 1 if days_left > 30
  	return 0
  end

  private 
  	def set_user_membership
  		user.update_column(:member, member_value)
	end
end
