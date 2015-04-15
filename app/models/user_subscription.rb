class UserSubscription < ActiveRecord::Base
  ### Relations
  belongs_to :user
  belongs_to :subscription
  belongs_to :creator, class_name: "User"
  # emun status: [:inactive, :active]


  def lifetime?
    subscription.subscription_type == Subscription::TYPES[:lifetime]
  end
end
