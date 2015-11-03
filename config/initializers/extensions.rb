require "mailboxer_extend"
Mailboxer::Notification.send(:include, MailboxerExtend)