class SuggesterUsers

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

  def committess
    profile.committees.pluck(:id).uniq || []
  end

  def aiesec_countries
    profile.experiences.aiesec.pluck(:country_id).uniq || []
  end

  def raw_results
    fetch_data
    @results
  end

  def results
    raw_results.values.flatten.uniq
  end

  private
    def profile
      user.profile
    end

    def fetch_data
      get_by_committees
      get_by_residence
      get_by_birth
    end

    def get_by_committees
      users_arrays = []
      profile.experiences.aiesec.each do |experience|
        users = User.active.joins(profile: :experiences).where(experiences: { exp_type: 0 })
          .where.not(id: user.id).uniq.limit(limit)
          .where(experiences: { committee_id: experience.committee_id })
          .where(experiences: { country_id: experience.country_id})
        users_arrays << users.to_a
      end
      @results[:committee] = users_arrays.flatten.uniq
    end

    def get_by_residence
      users_in_city = User.active.joins(:profile).where(profiles: { residence_city_id: residence_city })
        .where.not(id: user.id).uniq.limit(limit)
      @results[:residence_city] = users_in_city.to_a
      users_in_country =  User.active.joins(:profile).where(profiles: { residence_country_id: residence_country })
        .where.not(id: user.id).uniq.limit(limit)
      @results[:residence_country] = users_in_country.to_a
    end

    def get_by_birth
      users_in_city = User.active.joins(:profile).where(profiles: { birth_city_id: birth_city })
        .where.not(id: user.id).uniq.limit(limit)
      @results[:birth_city] = users_in_city.to_a
      users_in_country =  User.active.joins(:profile).where(profiles: { birth_country_id: birth_country })
        .where.not(id: user.id).uniq.limit(limit)
      @results[:birth_country] = users_in_country.to_a
    end
end