class SaveProfindaProfileJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    user.try(:save_data_in_profinda)
  end
end