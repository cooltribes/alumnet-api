module Global
  class SearchLocation

    attr_reader :result

    def initialize(term)
      @query = { name_cont: term }
    end

    def call
      @result = Country.ransack(@query).result | City.ransack(@query).result
    end

  end
end