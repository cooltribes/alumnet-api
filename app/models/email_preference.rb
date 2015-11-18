class EmailPreference < ActiveRecord::Base
	###Relations
	belongs_to :user

	### Validations
  validates_presence_of :user_id, :value, :name
end
