class Friendship < ActiveRecord::Base
  ###relations
  belongs_to :user
  belongs_to :friend, class_name: "User"
end
