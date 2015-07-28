class Payment < ActiveRecord::Base

  ### Relations
  belongs_to :user
  belongs_to :paymentable, polymorphic: true
end