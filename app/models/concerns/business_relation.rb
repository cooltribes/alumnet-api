class BusinessRelation
  include ActiveModel::Model

  attr_accessor :company_name, :company_logo, :offer, :search, :business_me,
    :keywords_offer, :keywords_search
  attr_reader :user

  validates_presence_of :company_name, :offer, :search, :keywords_search,
    :keywords_offer

  validate :keywords_is_array

  def initialize(attributes={}, user)
    super(attributes)
    @user = user
  end

  def company_params
    { name: company_name } #logo: @params["company_logo"]}
  end

  def company_relation_params
    { offer: offer, search: search, business_me: business_me }
  end

  def save
    if valid?
      company = create_company
      company_relation = create_company_relation(company)
      create_offer_keyword(company_relation)
      create_search_keyword(company_relation)
      company_relation
    else
      false
    end
  end

  def create_company
    user.profile.companies.create!(company_params)
  end

  def create_company_relation(company)
    company_relation = CompanyRelation.new(company_relation_params)
    company_relation.company = company
    user.profile.company_relations << company_relation
    company_relation
  end

  def create_offer_keyword(company_relation)
    keywords_offer.each do |name|
      keyword = Keyword.find_or_create_by(name: name)
      company_relation.company_relation_keywords.create(keyword: keyword, keyword_type: 0)
    end
  end

  def create_search_keyword(company_relation)
    keywords_search.each do |name|
      keyword = Keyword.find_or_create_by(name: name)
      company_relation.company_relation_keywords.create(keyword: keyword, keyword_type: 1)
    end
  end

  private

    def keywords_is_array
      errors.add(:keywords_offer, "must be an array") unless keywords_offer.is_a?(Array)
      errors.add(:keywords_search, "must be an array") unless keywords_search.is_a?(Array)
    end

end