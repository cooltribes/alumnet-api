json.(notification, :id, :body, :subject, :created_at)
receipt = notification.receipt_for(current_user).first
json.(receipt, :is_read)
