class DeleteProfindaTaskJob < ActiveJob::Base
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    task.delete_from_profinda
  end
end