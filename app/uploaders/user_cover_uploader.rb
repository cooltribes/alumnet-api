# encoding: utf-8

class UserCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base
  include AlumnetUploader::Crop

  version :main do
    process :crop!
    # process :resize_to_fill => [1600, 500]
  end

  version :crop do
    process :crop!
  end
end
