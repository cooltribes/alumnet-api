class Attendance < ActiveRecord::Base
  enum status: [:invited, :going, :maybe, :not_going]

  ###Relations
  belongs_to :user
  belongs_to :event

  ### Scopes
  scope :invited, -> { where(status: 0) }
  scope :going, -> { where(status: 1) }
  scope :maybe, -> { where(status: 2) }
  scope :not_going, -> { where(status: 3) }

  ### Validations
  validates_presence_of :event_id, :user_id

end
