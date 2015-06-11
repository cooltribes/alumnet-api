class TaskInvitation < ActiveRecord::Base
  ## Relations
  belongs_to :user
  belongs_to :task

  ## Validations
  validates_presence_of :user_id, :task_id

  ## Scopes
  scope :accepted, -> { where(accepted: true) }
  scope :not_accepted, -> { where(accepted: false) }

  ## Instances Methods
  def accept!
    update_column(:accepted, true)
    task.apply(user) if task && user
  end
end
