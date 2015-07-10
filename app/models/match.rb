class Match < ActiveRecord::Base
  ## Relations
  belongs_to :task
  belongs_to :user

  ## scopes
  scope :applied, -> { where(applied: true) }
  scope :not_applied, -> { where(applied: false) }

  ## Validations
  validates_presence_of :task_id, :user_id

  ## Instance methods

  def has_invitation
    TaskInvitation.exists?(user_id: user.id, task_id: task.id)
  end

  ## Class methods

  def self.delete_with_profinda_uid(profinda_uid)
    joins(:user).where.not(users: { profinda_uid: profinda_uid }).delete_all
  end
end
