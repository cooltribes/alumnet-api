# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include AlumnetUploader::Base
  include AlumnetUploader::Crop

  version :small do
    process :crop!
    process :resize_to_fill => [20,20]
  end

  version :medium do
    process :crop!
    process :resize_to_fill => [40,40]
  end

  version :large do
    process :crop!
    process :resize_to_fill => [80,80]
  end

  version :extralarge do
    process :crop!
    process :resize_to_fill => [240,240]
  end

  version :crop do
    process :crop!
  end

  def default_url
    Settings.api_endpoint + "/images/avatar/" + [version_name, "default_avatar.png"].compact.join('_')
  end
end
