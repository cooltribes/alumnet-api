class Experience < ActiveRecord::Base
  ### Relations
  belongs_to :region
  belongs_to :city
  belongs_to :country
  belongs_to :profile
  belongs_to :committee

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

end
