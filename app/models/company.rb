class Company < ActiveRecord::Base

  mount_uploader :logo, CompanyUploader

  ### Relations
  belongs_to :profile
  belongs_to :country
  belongs_to :city
  belongs_to :sector
  belongs_to :creator, class_name: 'User'
  has_many :company_relations, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_many :employment_relations, dependent: :destroy
  has_many :employees, through: :employment_relations, source: :user ##has_many users


  ### Validations
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false

  ### class Methods

  def self.find_by_name(name)
    ###Only postgres
    where('name ~* ?', name).first
  end

  def self.find_or_create_by_name(name, creator = nil)
    company = find_by_name(name)
    company = create(name: name, creator: creator) unless company
    company
  end

  def admins
    employees.where(employment_relations: { admin: true })
  end
end
