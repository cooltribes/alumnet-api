class TaskInvitation < ActiveRecord::Base
  ## Relations
  belongs_to :user
  belongs_to :task

  ## Instances Methods
  def accept!
    update_column(:accepted, true)
    task.apply(user) if task && user
  end
end
