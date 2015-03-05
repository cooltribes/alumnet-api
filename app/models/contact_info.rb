class ContactInfo < ActiveRecord::Base
  
  include ContactInfoHelpers
  acts_as_paranoid

  ###Constants
  CONTACT_TYPE = { 0 => 'Email', 1 => 'Phone', 2 => 'Skype', 3 => 'Yahoo',
    4 => 'Facebook', 5 => 'Twitter', 6 => 'IRC', 7 => 'Web Site' }

  ###Relations
  belongs_to :profile

  ###Validations
  validates_presence_of :info
end
