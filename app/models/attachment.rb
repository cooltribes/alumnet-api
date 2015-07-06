class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  ### Relations
  belongs_to :folder
  belongs_to :uploader, class_name: "User"

  ### Validations
  validates_presence_of :name, :file, :folder_id

  def user_can_download(user)
    if folder.folderable_type == "Group"
      folder.folderable.user_is_member?(user)
    elsif folder.folderable_type == "Event"
      folder.folderable.user_is_going?(user)
      true
    else
      false
    end
  end

  def user_can_edit(user)
    return true if uploader == user    

    if folder.folderable_type == "Group"
      folder.folderable.user_is_admin?(user)
    elsif folder.folderable_type == "Event"
      folder.folderable.is_admin?(user)
    else
      false
    end
  end


end
