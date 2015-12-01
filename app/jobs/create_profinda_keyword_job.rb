class CreateProfindaKeywordJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, keywords, keyword_type)
    user = User.find_by(id: user_id)
    Keyword.add_keywords_to_profinda(user, keywords, keyword_type) if user
  end
end