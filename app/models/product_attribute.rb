class ProductAttribute < ActiveRecord::Base
  belongs_to :attribute
  belongs_to :product
end
