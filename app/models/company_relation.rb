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
    create_relation_with_keywords(keywords, 0)
    Keyword.add_to_profinda(profile.user, keywords, 0) if profile
  end

  def search_keywords=(keywords)
    create_relation_with_keywords(keywords)
    Keyword.add_to_profinda(profile.user, keywords) if profile
  end

  def create_relation_with_keywords(keywords, keyword_type = 1)
    unless new_record?
      keyword_type == 0 ? offer_keywords.delete_all : search_keywords.delete_all
    end
    keywords.each do |name|
      keyword = Keyword.find_or_create_by(name: name)
      company_relation_keywords.create(keyword: keyword, keyword_type: keyword_type)
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
