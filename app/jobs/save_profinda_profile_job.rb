class SaveProfindaProfileJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.save_data_in_profinda
  end
end