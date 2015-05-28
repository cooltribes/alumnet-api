class Experience < ActiveRecord::Base
  include ExperienceHelpers
  acts_as_paranoid

  ### Relations
  belongs_to :region
  belongs_to :city
  belongs_to :country
  belongs_to :profile
  belongs_to :committee

  ### Callbacks
  after_save :update_profinda_profile

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

  private

    def update_profinda_profile
      profile.user.save_profinda_profile if profile.user.active?
    end

end
