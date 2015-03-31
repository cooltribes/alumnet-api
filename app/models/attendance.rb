class Attendance < ActiveRecord::Base
  enum status: [:invited, :going, :maybe, :not_going]

  ###Relations
  belongs_to :user
  belongs_to :event

  ### Validations
  validates_presence_of :event_id, :user_id

end
