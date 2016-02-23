module Suggesters
  class SuggesterGroups

    attr_reader :user, :limit

    def initialize(user, limit: 6)
      @user = user
      @limit = limit
      @results = {}
    end

    def raw_results
      fetch_data
      @results
    end

    def results
      raw_results.values.flatten.uniq
    end

    def aiesec_countries_ids
      profile.experiences.aiesec.pluck(:country_id).uniq || []
    end

    def profile_countries_ids
      [profile.residence_country_id, profile.birth_country_id]
    end

    def countries_ids
      [aiesec_countries_ids, profile_countries_ids].flatten.uniq
    end

    private

      def profile
        @profile ||= user.profile
      end

      def fetch_data
        groups = Group.where(country_id: countries_ids).not_secret
        # if groups.size < limit
        #   groups.to_a | Group.not_secret.order("RANDOM()").limit(limit - groups.size).to_a
        # else
        #   groups.limit(limit).to_a
        # end
        @results[:by_country] = groups.limit(limit).to_a
      end


  end
end