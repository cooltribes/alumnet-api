class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  ### Relations
  belongs_to :folder
  belongs_to :uploader, class_name: "User"

  ### Validations
  validates_presence_of :name, :file, :folder_id

  ### Callbacks
  # before_save :check_name

  def user_can_download(user)
    if folder.folderable_type == "Group"
      folder.folderable.user_is_member?(user)
    elsif folder.folderable_type == "Event"
      folder.folderable.user_is_going?(user)      
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

  def filename_and_extension_from_string(string)
    string_array = string.split(".")
    extension = string_array.pop
    filename = string_array.join(".")
    return filename, extension
  end

  private

    def check_name
      all_files = Folder.find(folder_id).attachments
      files = all_files.select { |f| f.name == name }
      if files.first
        filename, extension = filename_and_extension_from_string(name)
        self.name = "#{filename}(1).#{extension}"
      end
    end
end
