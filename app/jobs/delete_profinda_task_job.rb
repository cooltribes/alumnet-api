class DeleteProfindaTaskJob < ActiveJob::Base
  queue_as :profinda

  def perform(user_id, profinda_id)
    user = User.find_by(id: user_id)
    Task.delete_from_profinda(user, profinda_id) if user
  end
end