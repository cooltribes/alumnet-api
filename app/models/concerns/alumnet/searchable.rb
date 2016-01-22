module Alumnet
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      after_commit lambda { __elasticsearch__.index_document  },  on: [:create, :update]
      after_commit lambda { __elasticsearch__.delete_document },  on: :destroy

      index_name "#{self.model_name.collection.gsub(/\//, '-')}-#{Rails.env}" unless Rails.env.production?
    end

  end
end