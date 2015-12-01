class UpdateProfindaTaskJob < ActiveJob::Base
  include Rollbar::ActiveJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    task.try(:update_in_profinda)
  end
end