Layer::IdentityToken.layer_provider_id = Settings.layer.provider_id
Layer::IdentityToken.layer_key_id = Settings.layer.key_id
Layer::IdentityToken.layer_private_key = File.read(Settings.layer.private_key)