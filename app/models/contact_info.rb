class ContactInfo < ActiveRecord::Base
  ###Relations
  belongs_to :profile

  ###Validations
  validates_presence_of :info
end
