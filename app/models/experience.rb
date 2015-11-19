class Experience < ActiveRecord::Base
  acts_as_paranoid

  include Alumnet::Localizable

  include ExperienceHelpers

  # 0: 'aiesecExperience'
  # 1: 'alumniExperience'
  # 2: 'academicExperience'
  # 3: 'professionalExperience'
  # NOTE: Only exp_type 3 belongs to company

  ### Relations
  belongs_to :region
  belongs_to :profile
  belongs_to :committee
  belongs_to :seniority
  belongs_to :company

  ### Scopes
  scope :aiesec, -> { where(exp_type: 0) }
  scope :professional, -> { where(exp_type: 3) }
  scope :current, -> { where(exp_type: 3, current: true) }

  ###Callbacks
  before_save :check_end_date
  after_save :check_company

  ### Instances Class
  def region_info
    { id: region_id || "", text: region.try(:name) }
  end

  def company_info
    { id: company_id, text: company.try(:name) || organization_name }
  end

  def seniority_info
    { id: seniority_id, text: seniority.try(:name) }
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
      unless company_id.present? && exp_type == 3
        company = Company.find_by_name(organization_name)
        update_column(:company_id, company.id) if company
      end
    end
end
