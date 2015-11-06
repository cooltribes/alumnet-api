class CreateProfindaTaskJob < ActiveJob::Base
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    task.try(:create_in_profinda)
  end
end