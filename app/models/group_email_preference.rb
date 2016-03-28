class GroupEmailPreference < ActiveRecord::Base
	###Relations
	belongs_to :user
	belongs_to :group

	### Validations
  validates_presence_of :user_id, :group_id, :value
end
