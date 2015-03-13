class Album < ActiveRecord::Base
  belongs_to :user
  belongs_to :albumable, polymorphic: true

  def creator
    user
  end
end
