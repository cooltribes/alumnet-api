class ProfindaAdminApi
  include HTTParty
  include ActiveModel::Model

  attr_reader :last_response, :user
  validate :success_of_last_response

  base_uri Settings.profinda_api_endpoint
  format :json

  DEFAULT_HEADERS = {
    "Accept" => "application/vnd.profinda+json;version=1",
    "PROFINDAACCOUNTDOMAIN" => "cooltribes-staging.profinda.com"
  }

  ADMIN_CREDENTIALS = {
    user: 'admin@cooltribes.com',
    password: 'AlumNet2015'
  }

  ## Instance Methods

  def initialize
    @user = {}
    authenticate(ADMIN_CREDENTIALS[:user], ADMIN_CREDENTIALS[:password])
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

  def activate(uid)
    options = {
      headers: authorized_headers.merge({"Content-Type" => "application/json"}),
      body: { active: true }.to_json
    }
    @last_response = self.class.put("/admin/users/#{uid}/activate", options)
    @last_response.success?
  end

  def suspend(uid)
    options = {
      headers: authorized_headers.merge({"Content-Type" => "application/json"}),
      body: { active: false }.to_json
    }
    @last_response = self.class.put("/admin/users/#{uid}/suspend", options)
    @last_response.success?
  end

  ## class Methods
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