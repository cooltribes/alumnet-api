unless Mailboxer::Notification.included_modules.include?(MailboxerExtend)
  Mailboxer::Notification.send(:include, MailboxerExtend)
end