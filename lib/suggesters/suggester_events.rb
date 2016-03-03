module Suggesters
  class SuggesterEvents

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

      def profile
        user.profile
      end

      def fetch_data
        get_by_country_of_residence(days: 60, official: true)
        get_by_country_of_residence(days: 60, official: false)
        get_by_region_of_residence(days: 60, official: true)
        get_by_region_of_residence(days: 60, official: false)
        get_by_groups_belong_to_user(days: 60)
      end

      def get_by_country_of_residence(days:, official: true)
        data_range = [Date.today..(Date.today + days)]
        events = Event.where(country_id: residence_country, official: official, start_date: data_range)
          .where.not(creator_id: user.id).uniq.limit(@limit)
        name = "country_of_residence_#{days}#{ official ? "_official" : "" }".to_sym
        @results[name] = events.to_a
      end

      def get_by_region_of_residence(days: 60, official: false)
        data_range = [Date.today..(Date.today + days)]
        events = if region
          country_ids = region.country_ids
          Event.where(country_id: country_ids, official: official, start_date: data_range)
            .where.not(creator_id: user.id).uniq.limit(@limit)
        else
          []
        end
        name = "region_of_residence_#{days}#{ official ? "_official" : "" }".to_sym
        @results[name] = events.to_a
      end

      def get_by_groups_belong_to_user(days: 60)
        data_range = [Date.today..(Date.today + days)]
        group_ids = user.group_ids
        events = Event.where(start_date: data_range).where(eventable_id: group_ids, eventable_type: "Group")
          .where.not(creator_id: user.id).uniq.limit(@limit)
        @results[:groups_belong_to_user] = events.to_a
      end
  end
end