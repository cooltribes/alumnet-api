class ApprovalRequest < ActiveRecord::Base
  acts_as_paranoid

  ###relations
  belongs_to :user
  belongs_to :approver, class_name: "User"
  
  ###Instance Methods

  def request_type(user)
    if user_id == user.id
      "sent"
    elsif approver_id == user.id
      "received"
    end
  end

  def accept!
    unless accepted?
      update_column(:accepted, true)
      touch(:accepted_at)
      #Notification.notify_accepted_friendship_to_user(user, friend)
    end
  end
  
end
