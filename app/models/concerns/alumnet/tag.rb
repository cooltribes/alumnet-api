module Alumnet
  # this modules are for user tagging

  module Tag
    extend ActiveSupport::Concern
    included do
      has_many :user_taggings, dependent: :destroy
    end
  end
end