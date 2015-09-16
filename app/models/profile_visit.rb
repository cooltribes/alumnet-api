class ProfileVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :visitor
end
