class Company < ActiveRecord::Base

  mount_uploader :logo, CompanyUploader

  ### Relations
  belongs_to :profile
  belongs_to :country
  belongs_to :city
  belongs_to :sector
  has_many :company_relations, dependent: :destroy
  has_many :tasks, dependent: :destroy


  ### Validations
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

end
