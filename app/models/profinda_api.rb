class ProfindaApi
  include HTTParty
  include ActiveModel::Model

  attr_reader :last_response, :user
  validate :success_of_last_response

  base_uri Settings.profinda_api_endpoint
  format :json

  DEFAULT_HEADERS = {
    "Accept" => "application/vnd.profinda+json;version=1",
    "PROFINDAACCOUNTDOMAIN" => Settings.profinda_account_domain
  }

  ## Instance Methods

  def initialize(email, password, create = false)
    @user = {}
    if create
      create_user(email, password)
    else
      authenticate(email, password)
    end
  end

  def me
    options = { headers: authorized_headers, body: {} }
    @last_response = self.class.get("/me", options)
    @last_response.parsed_response
  end

  def profile
    options = { headers: authorized_headers, body: {} }
    @last_response = self.class.get("/profiles/#{user['id']}", options)
    @last_response.parsed_response
  end

  def custom_fields
    options = { headers: authorized_headers, body: {} }
    @last_response = self.class.get("/custom_fields", options)
    @last_response.parsed_response
  end

  def profile=(attributes)
    options = {
      headers: authorized_headers.merge({"Content-Type" => "application/json"}),
      body: attributes.to_json
    }
    @last_response = self.class.put("/profiles/#{user['id']}", options)
    @last_response.parsed_response
  end

  ## class Methods

  def self.sign_up(email, password)
    new(email, password, true)
  end

  def self.sign_in_or_sign_up(email, password)
    ##TODO: Improve this
    profinda = new(email, password)
    profinda = sign_up(email, password) unless profinda.valid?
    profinda
  end

  protected
    def authorized_headers
      DEFAULT_HEADERS.merge({"PROFINDAAPITOKEN" => user["authentication_token"]})
    end

    def authenticate(email, password)
      options = {
        headers: DEFAULT_HEADERS.merge({"Content-Type" => "application/json"}),
        body: { user: { email: "#{email}", password: "#{password}" } }.to_json
      }
      @last_response = self.class.post("/auth/sign_in", options)
      if @last_response.success?
        @user = @last_response.parsed_response
      end
    end

    def create_user(email, password)
      options = {
        headers: DEFAULT_HEADERS.merge({"Content-Type" => "application/x-www-form-urlencoded"}),
        body: { user: { account_id: 4, email: "#{email}", password: "#{password}" } }
      }
      @last_response = self.class.post("/auth/sign_up", options)
      if @last_response.success?
        @user = @last_response.parsed_response
      end
    end

    def success_of_last_response
      if !last_response.success? && last_response["errors"] && last_response["errors"].any?
        last_response["errors"].each do |key, value|
          value.each do |message|
            errors.add(key.to_sym, message)
          end
        end
      end
    end
end