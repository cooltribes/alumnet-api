class Attendance < ActiveRecord::Base

  ###Relations
  belongs_to :user
  belongs_to :event

end
