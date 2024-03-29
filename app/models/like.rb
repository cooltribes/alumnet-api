class Like < ActiveRecord::Base
  acts_as_paranoid

  ### Ralations
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  ### Validations
  validates_uniqueness_of :user_id, scope: [:likeable_id, :likeable_type],
    message: "already made like!"

  after_create :notify_to_author

  scope :without_user, ->(user) { where.not(user_id: user.id)}

  ### Instance methods

  def owner
    self.user
  end

  def is_owner?(user)
    self.user == user
  end

  private

    def notify_to_author
      Notification.notify_like(self)
    end
end
