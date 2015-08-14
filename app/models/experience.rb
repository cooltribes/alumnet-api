class Experience < ActiveRecord::Base
  include ExperienceHelpers
  acts_as_paranoid

  # 1: 'aiesecExperience'
  # 1: 'alumniExperience'
  # 2: 'academicExperience'
  # 3: 'professionalExperience'

  ### Relations
  belongs_to :region
  belongs_to :city
  belongs_to :country
  belongs_to :profile
  belongs_to :committee
  belongs_to :seniority
  belongs_to :company

  ###Callbacks
  before_save :check_end_date
  after_save :check_company

  ### Instances Class
  def get_info_region
    region.present? ? { id: region.id, text: region.name } : nil
  end

  def get_info_city
    city.present? ? { id: city.id, text: city.name } : nil
  end

  def get_info_country
    country.present? ? { id: country.id, text: country.name } : nil
  end

  ### Class Methods

  def self.non_alumnet
    where("exp_type = 2 or exp_type = 3")
  end

  def self.aisec
    where(exp_type: 0)
  end

  private
    def check_end_date
      if exp_type == 3 && end_date == nil && current == false
        self[:current] = true
      end
    end

    def check_company
      unless company_id.present?
        company = Company.find_by_name(organization_name)
        update_column(:company_id, company.id) if company
      end
    end
end
