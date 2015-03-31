class Subscription < ActiveRecord::Base
  has_many :user_subscriptions
  has_many :users, through: :user_subscriptions
end
