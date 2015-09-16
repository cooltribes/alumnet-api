module Alumnet
  module Croppable
    extend ActiveSupport::Concern

    included do
      attr_accessor :imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH
    end

    def crop(image)
      send(image).recreate_versions! if imgX1.present?
      save!
    end

    def crop_url(image)
      send(image).crop.url
    end
  end
end