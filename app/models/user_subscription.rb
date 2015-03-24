class UserSubscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription
  belongs_to :creator, class_name: "User"
end
