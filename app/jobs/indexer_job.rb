class IndexerJob < ActiveJob::Base
  queue_as :indexer
  sidekiq_options retry: 5

  rescue_from(ActiveJob::DeserializationError) do |exception|
   # do something with the exception
  end

  def client
    @client ||= Elasticsearch::Client.new(host: Settings.elasticsearch_url, log: true)
  end

  def perform(record, operation)
    model = record.class
    raise ArgumentError, "the record cannot be indexed" unless AlumnetSearcher::SEARCHEABLE_MODELS.include?(model)

    case operation.to_s
    when /index/
      client.index(index: model.__elasticsearch__.index_name,
                   type: model.__elasticsearch__.document_type,
                   id: record.id,
                   body: record.as_indexed_json)
    when /delete/
      client.delete(index: model.__elasticsearch__.index_name,
                    type: model.__elasticsearch__.document_type,
                    id: record.id)
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end