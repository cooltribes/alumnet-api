class Company < ActiveRecord::Base

  mount_uploader :logo, LogoUploader

  SIZE = {
    1 => "1 - 10",
    2 => "11 - 50",
    3 => "51 - 200",
    4 => "201 - 500",
    5 => "501 - 1.000",
    6 => "1.001 - 5.000",
    7 => "5.001 - 10.000",
    8 => "+10.001"
  }

  ### Relations
  belongs_to :profile
  belongs_to :country
  belongs_to :city
  belongs_to :sector
  belongs_to :creator, class_name: 'User'
  has_many :company_relations, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_many :experiences
  has_many :profiles, through: :experiences
  has_many :branches, dependent: :destroy
  has_many :contact_infos, as: :contactable, dependent: :destroy
  has_many :company_admins, dependent: :destroy
  has_many :admins, through: :company_admins, source: :user
  has_and_belongs_to_many :product_services, dependent: :destroy

  ### Validations
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false


  ### class Methods

  def self.find_by_name(name)
    ###Only postgres
    where('name ~* ?', name).first
  end

  ### instance Methods

  def accepted_admins
    admins.where(company_admins: { status: 1 })
  end

  def is_admin?(user)
    accepted_admins.include?(user)
  end

  def employees
    profiles.where(experiences: { current: true }).distinct
  end

  def past_employees
    profiles.where(experiences: { current: false }).distinct
  end

  def country_info
    country ? { text: country.name, value: country_id } : { text: "", value: ""}
  end

  def city_info
    city ? { text: city.name, value: city_id } : { text: "", value: ""}
  end

  def sector_info
    sector ? { text: sector.name, value: sector_id } : { text: "", value: ""}
  end

  def size_info
    { text: SIZE[size], value: size}
  end
end
