CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     'AKIAJIODQVPOZ723IRUA',
      aws_secret_access_key: '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',
      region:                'eu-central-1'
    }
    config.fog_directory  = Settings.fog_directory
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  else
    config.storage :file
    config.asset_host Settings.api_endpoint
  end
end