class CreateProfindaKeywordJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, keywords, keyword_type)
    user = User.find(user_id)
    Keyword.add_keywords_to_profinda(user, keywords, keyword_type)
  end
end