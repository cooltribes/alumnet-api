class Payment < ActiveRecord::Base

  ### Relations
  belongs_to :user
  belongs_to :paymentable, polymorphic: true
  has_one :country, dependent: :destroy
  has_one :city, dependent: :destroy
end
