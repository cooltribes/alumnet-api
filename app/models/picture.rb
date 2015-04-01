class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :pictureable, polymorphic: true
  mount_uploader :picture, PictureUploader

end
