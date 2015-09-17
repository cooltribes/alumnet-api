
redis_db = { 'development' => 0, 'staging' => 0, 'production' => 1}

Sidekiq.configure_server do |config|
  config.redis = { namespace: Rails.env, url: "redis://127.0.0.1:6379/#{redis_db[Rails.env]}" }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: Rails.env, url: "redis://127.0.0.1:6379/#{redis_db[Rails.env]}" }
end