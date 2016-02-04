module Alumnet
  module Localizable
    extend ActiveSupport::Concern

    included do
      belongs_to :country
      belongs_to :city
    end

    # This methods return formatted info for json
    def city_info
      { name: city.try(:name) || "", id: city_id, cc_iso: city.try(:cc_iso) }
    end

    def country_info
      { name: country.try(:name) || "", id: country_id, cc_iso: country.try(:cc_iso) }
    end
  end
end