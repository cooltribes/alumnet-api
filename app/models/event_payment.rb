class UserSubscription < ActiveRecord::Base
  ### Relations
  belongs_to :user
  belongs_to :event
  belongs_to :attendance
end
