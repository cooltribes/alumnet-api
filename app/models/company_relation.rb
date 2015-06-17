class CompanyRelation < ActiveRecord::Base

  ### Relations
  belongs_to :profile
  belongs_to :company
  # has_many :business_infos, dependent: :destroy
  has_many :company_relation_keywords, dependent: :destroy
  has_many :keywords, through: :company_relation_keywords
  has_many :links, dependent: :destroy, foreign_key: :company_relation_id


  ### Validations
  validates_presence_of :offer, :search

  ### instance methods

  def offer_keywords=(keywords)
    return false unless keywords.is_a?(Array)
    offer_keywords.delete_all unless new_record?
    keywords.each do |kw|
      keyword = Keyword.find_or_create_by(name: kw)
      company_relation_keywords.create(keyword: keyword, keyword_type: 0)
    end
  end

  def search_keywords=(keywords)
    return false unless keywords.is_a?(Array)
    search_keywords.delete_all unless new_record?
    keywords.each do |kw|
      keyword = Keyword.find_or_create_by(name: kw)
      company_relation_keywords.create(keyword: keyword, keyword_type: 1)
    end
  end

  def offer_keywords
    company_relation_keywords.where(keyword_type: 0)
  end

  def offer_keywords_name
    keywords.where(company_relation_keywords: {keyword_type: 0 })    
  end

  def search_keywords
    company_relation_keywords.where(keyword_type: 1)    
  end

  def search_keywords_name
    keywords.where(company_relation_keywords: {keyword_type: 1 })       
  end

end
