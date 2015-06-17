class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  ### Relations
  belongs_to :folder
  belongs_to :uploader, class_name: "User"

  ### Validations
  validates_presence_of :name, :file, :folder_id
end
