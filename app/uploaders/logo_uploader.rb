# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base
  include AlumnetUploader::Crop

  version :main do
    process :crop!
    process :resize_to_fit => [800, 600]
  end

  version :card do
    process :crop!
    process :resize_to_fit => [212, 225]
  end

  version :crop do
    process :crop!
  end

  def default_url
    Settings.api_endpoint + "/images/logo/" + [version_name, "default_avatar.png"].compact.join('_')
  end

end
