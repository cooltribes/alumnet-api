class EmploymentRelation < ActiveRecord::Base
  ### Relations
  belongs_to :user
  belongs_to :company
end
