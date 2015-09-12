module Alumnet
  module Localizable
    extend ActiveSupport::Concern
    included do
      belongs_to :country
      belongs_to :city
    end

    # This methods return formatted info for json
    def info_city
      { name: city.try(:name) || "", id: city_id || "", cc_iso: nil }
    end

    def info_country
      { name: country.try(:name) || "", id: country_id || "", cc_iso: nil }
    end
  end
end