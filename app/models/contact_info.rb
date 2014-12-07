class ContactInfo < ActiveRecord::Base
  ###Constants
  CONTACT_TYPE = { 0 => 'Email', 1 => 'Phone', 2 => 'Skype', 3 => 'Yahoo',
    4 => 'Facebook', 5 => 'Twitter', 6 => 'IRC' }

  ###Relations
  belongs_to :profile

  ###Validations
  validates_presence_of :info
end
