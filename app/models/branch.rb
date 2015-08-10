class Branch < ActiveRecord::Base
  ###Relations
  belongs_to :company
  belongs_to :country
  belongs_to :city

  ###Validationes
  validates_presence_of :address

  ###Instance Methods
  def country_info
    country ? { text: country.name, value: country_id } : { text: "", value: ""}
  end

  def city_info
    city ? { text: city.name, value: city_id } : { text: "", value: ""}
  end
end
