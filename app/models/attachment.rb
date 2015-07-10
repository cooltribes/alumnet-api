class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  ### Relations
  belongs_to :folder
  belongs_to :uploader, class_name: "User"

  ### Validations
  validates_presence_of :name, :file, :folder_id

  ### Callbacks
  # before_save :check_name

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
