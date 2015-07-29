# encoding: utf-8

class PrizeUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base
  include AlumnetUploader::Crop

  version :main do
    process :crop!
    process :resize_to_fit => [1360, 430]
  end

  version :card do
    process :crop!
    process :resize_to_fill => [212, 225]
  end

  version :admin do
    process :crop!
    process :resize_to_fill => [60, 60]
  end

  version :crop do
    process :crop!
  end
end