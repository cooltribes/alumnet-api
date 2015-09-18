class Branch < ActiveRecord::Base
  include Alumnet::Localizable

  ###Relations
  belongs_to :company
  has_many :contact_infos, as: :contactable, dependent: :destroy

  ###Validationes
  validates_presence_of :address

end
