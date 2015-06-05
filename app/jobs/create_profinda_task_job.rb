class CreateProfindaTaskJob < ActiveJob::Base
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    task.create_in_profinda
  end
end