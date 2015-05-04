# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base

  version :main do
    process :resize_to_fit => [1360, 430]
  end

  version :card do
    process :resize_to_fit => [212, 225]
  end

  version :modal do
    process :resize_to_fit => [800, 600]
  end

end
