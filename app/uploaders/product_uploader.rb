# encoding: utf-8

class ProductUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base

  version :main do
    process :resize_to_fit => [1360, 430]
  end

  version :card do
    process :resize_to_fill => [212, 225]
  end

  version :admin do
    process :resize_to_fill => [60, 60]
  end

end
