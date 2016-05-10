class ProductCharacteristic < ActiveRecord::Base
	belongs_to :characteristic
  belongs_to :product
end
