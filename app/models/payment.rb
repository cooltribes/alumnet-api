class Payment < ActiveRecord::Base
	attr_accessor :user_product_id
  ### Relations
  belongs_to :user
  belongs_to :paymentable, polymorphic: true

  def get_country_name
  	country_id.present? ? Country.find(country_id).name : nil
  end
end