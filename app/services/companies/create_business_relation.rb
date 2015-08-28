module Companies
  class CreateBusinessRelation
    include ActiveModel::Model

    attr_accessor :company_name, :company_logo, :offer, :search, :tagline,
      :business_me, :offer_keywords, :search_keywords

    attr_reader :user, :company_relation

    validates_presence_of :company_name, :offer, :search, :search_keywords,
      :offer_keywords

    validate :keywords_is_array

    def initialize(attributes={}, user)
      super(attributes)
      @user = user
    end

    def company_params
      { name: company_name, creator: user }
    end

    def company_relation_params
      { offer: offer, search: search, business_me: business_me }
    end

    def call
      if valid?
        company = create_company
        @company_relation = create_company_relation(company)
        create_offer_keyword(@company_relation)
        create_search_keyword(@company_relation)
        @company_relation.save
      else
        false
      end
    end

    def create_company
      Company.create!(company_params)
    end

    def create_company_relation(company)
      company_relation = CompanyRelation.new(company_relation_params)
      company_relation.company = company
      user.profile.company_relations << company_relation
      company_relation
    end

    def create_offer_keyword(company_relation)
      company_relation.offer_keywords = offer_keywords
    end

    def create_search_keyword(company_relation)
      company_relation.search_keywords = search_keywords
    end

    private

      def keywords_is_array
        errors.add(:offer_keywords, "must be an array") unless offer_keywords.is_a?(Array)
        errors.add(:search_keywords, "must be an array") unless search_keywords.is_a?(Array)
      end
  end
end