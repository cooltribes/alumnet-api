class BusinessRelation

  attr_reader :user, :company

  def initialize(params, user)
    @user = user
    @company_params = params[:company]
    @company_relation_params = { offer: params[:offer], search: params[:search],
      business_me: params[:business_me] }
    @offer_keywords = params[:keywords][:offer]
    @search_keywords = params[:keywords][:search]
  end

  def save
    if create_company
      if create_company_relation
        create_offer_keyword
        create_search_keyword
        true
      else
        false
      end
    else
      false
    end
  end

  def create_company
    @company = Company.new(@company_params)
    user.profile.companies << @company
  end

  def create_company_relation
    @company_relation = CompanyRelation.new(@company_relation_params)
    @company_relation.company = @company
    user.profile.company_relations << @company_relation
  end

  def create_offer_keyword
    @offer_keywords.each do |name|
      keyword = Keyword.find_or_create_by(name: name)
      @company_relation.company_relation_keywords.create(keyword: keyword, keyword_type: 0)
    end
  end

  def create_search_keyword
    @search_keywords.each do |name|
      keyword = Keyword.find_or_create_by(name: name)
      @company_relation.company_relation_keywords.create(keyword: keyword, keyword_type: 1)
    end
  end

  def errors
    @company.try(:errors) || @company_relation_keywords.try(:errors) || @company_relations.try(:errors)
  end

end