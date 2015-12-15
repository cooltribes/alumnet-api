module Alumnet
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
      index_name "#{self.model_name.collection.gsub(/\//, '-')}-#{Rails.env}" unless Rails.env.production?
    end

  end
end