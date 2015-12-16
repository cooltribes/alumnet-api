class Keyword < ActiveRecord::Base
  ### Relations
  has_and_belongs_to_many :business_infos
  has_many :company_relation_keywords
  has_many :company_relations, through: :company_relation_keywords

  ### Validations
  validates_presence_of :name

  ### Class Methods
  def self.add_keywords_to_profinda(user, keywords, keyword_type = 1)
    key = keyword_type == 0 ? "pcf_alumnet_business_exchange_offers" : "pcf_alumnet_business_exchange_search"
    profinda_api = ProfindaApiClient.new(user.email, user.profinda_password)
    profinda_api.profile = { key => keywords.join("&#x2c;") }
  end

  def self.add_to_profinda(user, keywords, keyword_type = 1)
    CreateProfindaKeywordJob.perform_later(user.id, keywords, keyword_type)
  end

end
