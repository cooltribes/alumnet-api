# encoding: utf-8

class UserCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  version :main do
    process :crop!
    process :resize_to_fill => [1360,430]
  end

  version :crop do
    process :crop!
  end

  def crop!
    if model.imgX1.present?
      imgW = model.imgW.to_i
      imgH = model.imgH.to_i
      imgX1 = model.imgX1.to_i
      imgY1 = model.imgY1.to_i
      cropW = model.cropW.to_i
      cropH = model.cropH.to_i
      resize_to_limit(imgW, imgH)
      manipulate! do |img|
        img.crop "#{cropW}x#{cropH}+#{imgX1}+#{imgY1}"
      end
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
