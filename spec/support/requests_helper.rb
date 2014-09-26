module RequestsHelper

  def json
    @json ||= JSON.parse(response.body)
  end

  def basic_header(auth_token)
    {
      'Accept' => 'application/vnd.alumnet+json; version=1',
      'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_token)
    }
  end

end