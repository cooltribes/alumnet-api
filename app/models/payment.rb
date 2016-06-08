class Payment < ActiveRecord::Base
	attr_accessor :user_product_id
  ### Relations
  belongs_to :user
  belongs_to :paymentable, polymorphic: true
end