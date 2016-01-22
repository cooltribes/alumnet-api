module Alumnet
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      after_commit :create_elasticsearch_index,  on: [:create, :update]
      after_commit :delete_elasticsearch_index,  on: :destroy

      index_name "#{self.model_name.collection.gsub(/\//, '-')}-#{Rails.env}" unless Rails.env.production?
    end

    private


      #relation es un hack para poder utilizar estos metodos en los callbacks de relaciones(:after_add)
      def create_elasticsearch_index(relation = nil)
        IndexerJob.perform_later(self, 'index')
      end

      def delete_elasticsearch_index(relation = nil)
        IndexerJob.perform_later(self, 'delete')
      end

  end
end