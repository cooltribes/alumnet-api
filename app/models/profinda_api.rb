class ProfindaApi
  include HTTParty
  include ActiveModel::Model

  attr_reader :last_response, :user
  validate :success_of_last_response

  base_uri Settings.profinda_api_endpoint
  format :json

  ## Tasks help_type
  # "task_business_exchange"
  # "task_home_exchange"
  # "task_job_exchange"
  # "task_meetup_exchange"my

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

  def api_token
    return user.any? ? user["authentication_token"] : ""
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

  def search_by_type(term, type)
    options = { headers: authorized_headers, body: {}, query: { term: term, type: type } }
    @last_response = self.class.get("/autocomplete/dictionary_objects", options)
    @last_response.parsed_response
  end

  def search_by_suggestion(term)
    options = { headers: authorized_headers, body: {}, query: { term: term } }
    @last_response = self.class.get("/autocomplete/suggestions", options)
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

  def create_task(attributes, type = "task_job_exchange")
    # attributes = { "post_until" => "29/05/2015", "description" => "testing taks", "help_type_id" => "8", "nice_have_list" => "1638,1590,1636", "must_have_list" => "1637,1606", "duration" => "hours", "name" => "Testing Task" }
    default_attributes = { "user_relation" => {}, "profile_id" => nil, "attachment" => "",
      "match_suspended_users" => false, "help_type_id" => help_types[type] }
    attributes.merge!(default_attributes)
    options = {
      headers: authorized_headers.merge({"Content-Type" => "application/json"}),
      body: attributes.to_json
    }
    @last_response = self.class.post("/tasks", options)
    @last_response.parsed_response
  end

  def update_task(id, attributes)
    options = {
      headers: authorized_headers.merge({"Content-Type" => "application/json"}),
      body: attributes.to_json
    }
    @last_response = self.class.put("/tasks/#{id}", options)
    @last_response.parsed_response
  end

  def delete_task(id)
    options = {
      headers: authorized_headers.merge({"Content-Type" => "application/json"}),
      body: {}
    }
    @last_response = self.class.delete("/tasks/#{id}", options)
    @last_response.parsed_response
  end

  def matches(task_id)
    profinda_matches = task_matches(task_id)
    users = []
    if profinda_matches["entries"].present?
      profinda_matches["entries"].map do |match|
        users << match["profile_id"]
      end
    end
    users
  end

  def task_matches(id)
    options = { headers: authorized_headers, body: {} }
    @last_response = self.class.get("/tasks/#{id}/matches", options)
    @last_response.parsed_response
  end

  def help_types
    unless @help_types
      @help_types = {}
      options = { headers: authorized_headers, body: {}, query: { term: nil, type: "help_type_id" } }
      @last_response = self.class.get("/autocomplete/help_types", options)
      @last_response.parsed_response.each { |ht| @help_types[ht["text"]] = ht["id"] }
    end
    @help_types
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
