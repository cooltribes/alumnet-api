class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  ### Relations
  belongs_to :folder
  belongs_to :uploader, class_name: "User"
end
