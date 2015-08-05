class Branch < ActiveRecord::Base
  ###Relations
  belongs_to :company

  ###Validationes
  validates_presence_of :address

end
