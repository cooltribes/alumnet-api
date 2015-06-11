class TaskInvitation < ActiveRecord::Base
  ## Relations
  belongs_to :user
  belongs_to :task
end
