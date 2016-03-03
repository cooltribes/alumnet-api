module Suggesters
  class SuggesterCompanies

    attr_reader :user, :limit

    GEO_ATTR = ["residence_city", "residence_country", "birth_city", "birth_country"]

    def initialize(user, limit: 6)
      @user = user
      @limit = limit
      @results = {}
    end

    GEO_ATTR.each do |geo_attr|
      define_method("#{geo_attr}") do
        profile.send("#{geo_attr}_id")
      end
    end

    def raw_results
      fetch_data
      @results
    end

    def results
      raw_results.values.flatten.uniq
    end

    private
      def region
        profile.residence_country.try(:region)
      end

      def user_sector_ids
        []
      end

      def profile
        user.profile
      end

      def fetch_data
        get_by_sector
        get_by_country_of_residence
        get_by_region_of_residence
        get_by_city_of_residence
      end

      def get_by_sector
        companies = Company.where(sector_id: user_sector_ids)
        @results[:sector] = companies.to_a
      end

      def get_by_country_of_residence
        companies = Company.where(country_id: residence_country)
        @results[:country_of_residence] = companies.to_a
      end

      def get_by_city_of_residence
        companies = Company.where(city_id: residence_city)
        @results[:city_of_residence] = companies.to_a
      end

      def get_by_region_of_residence
        companies = if region
          country_ids = region.country_ids
          Company.where(country_id: country_ids)
        else
          []
        end
        @results[:region_of_residence] = companies.to_a
      end
  end
end