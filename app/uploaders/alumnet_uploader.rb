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

        imgW = model.imgW.to_f
        imgH = model.imgH.to_f
        imgInitW = model.imgInitW.to_f
        imgInitH = model.imgInitH.to_f
        ratioW = imgInitW/imgW
        ratioH = imgInitH/imgH
        ratio = [ratioW, ratioH].min
        # imgX1 = model.imgX1.to_i * (1600/450)
        # imgY1 = model.imgY1.to_i * (560/150)
        # cropW = model.cropW.to_i * (1600/450)
        # cropH = model.cropH.to_i * (560/150)
        
        #imgX1 = (model.imgX1.to_i * ratioW).floor
        #imgY1 = (model.imgY1.to_i * ratioH).floor
        
        cropW = model.cropW.to_f #* ratio
        cropH = model.cropH.to_f #* ratio
        imgX1 = model.imgX1.to_f #* ratio
        imgY1 = model.imgY1.to_f #* ratio
        #cropW = model.cropW.to_i
        #cropH = model.cropH.to_i
        #cropW = 349
        #cropH = 349
        #imgX1 = 0
        #imgY1 = 0

        #if model.image == "cover"
        #  cropW = 1360 * ratio
        #  cropH = 430 * ratio
        #end

        #resize_to_limit(imgInitW, imgInitH)   
        
        manipulate! do |img|
          img.crop "#{cropW}x#{cropH}+#{imgX1}+#{imgY1}"
          #img.resize "1360x430"       
        end
      end
    end
  end
end
