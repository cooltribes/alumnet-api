# encoding: utf-8

module AlumnetUploader

  module Base

    def filename
      if original_filename
        if model && model.read_attribute(mounted_as).present?
          model.read_attribute(mounted_as)
        else
          "#{secure_token}.#{file.extension}"
        end
      end
    end

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    protected
      def secure_token
        var = :"@#{mounted_as}_secure_token"
        model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
      end
  end

  module Crop

    def crop!
      if model.imgX1.present?
        imgW = model.imgW.to_i
        imgH = model.imgH.to_i
        imgInitW = model.imgInitW.to_i
        imgInitH = model.imgInitH.to_i
        ratioW = imgInitW/imgW
        ratioH = imgInitH/imgH
        ratio = [ratioW, ratioH].min
        # imgX1 = model.imgX1.to_i * (1600/450)
        # imgY1 = model.imgY1.to_i * (560/150)
        # cropW = model.cropW.to_i * (1600/450)
        # cropH = model.cropH.to_i * (560/150)
        imgX1 = model.imgX1.to_i * ratio
        imgY1 = model.imgY1.to_i * ratio
        #cropW = model.cropW.to_i
        #cropH = model.cropH.to_i
        cropW = 1360
        cropH = 430
        resize_to_limit(imgInitW, imgInitH)        
        manipulate! do |img|
          img.crop "#{cropW}x#{cropH}+#{imgX1}+#{imgY1}"
          #img.resize "1360x430"       
        end
      end
    end
  end
end
