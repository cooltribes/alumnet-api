class Payment < ActiveRecord::Base
  acts_as_paranoid

  ### Relations
  belongs_to :user
  belongs_to :payable, polymorphic: true
end
