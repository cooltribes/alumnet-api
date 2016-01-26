module Global
  class SearchLocation

    attr_reader :result

    def initialize(query)
      @query = query
    end

    def call
      @result = Country.ransack(@query).result | City.ransack(@query).result
    end

  end
end