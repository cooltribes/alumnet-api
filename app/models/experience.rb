class Experience < ActiveRecord::Base
  include ExperienceHelpers
  acts_as_paranoid

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

end
