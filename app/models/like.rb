class Like < ActiveRecord::Base
  acts_as_paranoid

  ### Ralations
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  ### Validations
  validates_uniqueness_of :user_id, scope: [:likeable_id, :likeable_type],
    message: "already made like!"

  after_create :notify_to_author

  private

    def notify_to_author
      Notification.notify_like(self)
    end
end
