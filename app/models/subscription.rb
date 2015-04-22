class Subscription < ActiveRecord::Base
  ### Constants
  TYPES = { premium: 1, lifetime: 2 }
  # emun status: [:inactive, :active]

  ### Relations
  has_many :user_subscriptions
  has_many :users, through: :user_subscriptions

  ###Scopes
  scope :premium, -> { where(name: 'Premium') }
  scope :lifetime, -> { where(name: 'Premium Lifetime') }
end
