# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base


  version :card do
    process :resize_to_fit => [212, 225]
  end

  version :main do
    process :resize_to_fit => [800, 600]
  end

end
