require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(url: Settings.elasticsearch_url, logs: true)
