class UserTagging < ActiveRecord::Base
  serialize :position, Hash

  ### Relations
  belongs_to :user
  belongs_to :tagger, class_name: 'User'
  belongs_to :taggable, polymorphic: true

  ### Callbacks
  after_save :send_notification

  private
    def send_notification
      Notification.notify_tagging(self)
    end
end
