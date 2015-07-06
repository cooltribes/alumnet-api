class Folder < ActiveRecord::Base
  ### Relations
  belongs_to :folderable, polymorphic: true
  belongs_to :creator, class_name: "User"
  has_many :attachments, dependent: :destroy

  ### Validations
  validates_presence_of :name

  def files_count
    self.attachments.count
  end

  def user_can_edit(user)

    return true if creator == user    

    if folderable_type == "Group"
      folderable.user_is_admin?(user)
    elsif folderable_type == "Event"
      folderable.is_admin?(user)
    else
      false
    end
    
  end
end
