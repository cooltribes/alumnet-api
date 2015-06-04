class DeleteProfindaTaskJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, profinda_id)
    user = User.find(user_id)
    Task.delete_from_profinda(user, profinda_id)
  end
end