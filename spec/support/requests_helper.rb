module RequestsHelper

  def json
    @json ||= JSON.parse(response.body)
  end

  def basic_header(auth_token)
    {
      'Accept' => 'application/vnd.alumnet+json;version=1',
      'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_token)
    }
  end

  def get_schema(name)
    "#{Rails.root}/public/docs/v1/schemas/#{name}.json"
  end

  def valid_schema(schema, data)
    JSON::Validator.fully_validate(get_schema(schema), data)
  end
end