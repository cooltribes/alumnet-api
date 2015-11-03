module MailboxerExtend
  extend ActiveSupport::Concern

  included do
    has_one :notification_detail, foreign_key: "mailboxer_notification_id"
  end

end

Mailboxer::Notification.send(:include, MailboxerExtend)