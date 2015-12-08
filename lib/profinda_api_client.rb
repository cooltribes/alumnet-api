class ProfindaApiClient
  include HTTParty
  include ActiveModel::Model

  attr_reader :last_response, :user

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

  def initialize(email, password, create: false)
    @valid = true
    if create
      register(email, password)
    else
      authenticate(email, password)
    end
  end

  def valid?
    @valid
  end

  def api_token
    user ? user.authentication_token : nil
  end

  def me
    get("/me")
  end

  def profile
    return unless user
    get("/profiles/#{user.id}")
  end

  def custom_fields
    get("/custom_fields")
  end

  def search_by_type(term, type)
    get("/autocomplete/dictionary_objects", { query: { term: term, type: type } })
  end

  def search_by_suggestion(term)
    get("/autocomplete/suggestions", { query: { term: term } })
  end

  def profile=(attributes)
    put("/profiles/#{user.id}", { body: attributes.to_json })
  end

  def help_types
    unless @help_types
      @help_types = {}
      response = get("/autocomplete/help_types", { query: { term: nil, type: "help_type_id" } })
      response.each { |ht| @help_types[ht["text"]] = ht["id"] }
    end
    @help_types
  end

  ### TASKS
  def create_task(attributes, type = "task_job_exchange")
    # attributes = { "post_until" => "29/05/2015", "description" => "testing taks", "help_type_id" => "8", "nice_have_list" => "1638,1590,1636", "must_have_list" => "1637,1606", "duration" => "hours", "name" => "Testing Task" }
    default_attributes = { "user_relation" => {}, "profile_id" => nil, "attachment" => "",
      "match_suspended_users" => false, "help_type_id" => help_types[type] }
    attributes.merge!(default_attributes)
    post("/tasks", { body: attributes.to_json })
  end

  def update_task(id, attributes)
    put("/tasks/#{id}", { body: attributes.to_json })
  end

  def delete_task(id)
    delete("/tasks/#{id}")
  end

  ### MATCHES
  def task_matches(id)
    get("/tasks/#{id}/matches")
  end

  def tasks_automatches
    get("/tasks/automatches")
  end

  def matches(task_id)
    profinda_matches = task_matches(task_id)
    users = []
    if profinda_matches && profinda_matches["entries"].present?
      profinda_matches["entries"].each do |match|
        users << match["profile_id"]
      end
    end
    users
  end

  def automatches
    profinda_automatches = tasks_automatches
    tasks = []
    if profinda_automatches && profinda_automatches["entries"].present?
      profinda_automatches["entries"].each do |match|
        tasks << match["id"]
      end
    end
    tasks
  end

  ### AUTHENTICATION AND REGISTER
  def authenticate(email, password)
    options = {
      headers: DEFAULT_HEADERS.merge({"Content-Type" => "application/json"}),
      body: { user: { email: "#{email}", password: "#{password}" } }.to_json
    }
    @last_response = handle_request { self.class.post("/auth/sign_in", options) }
    @user = handle_response(@last_response)
  end

  def register(email, password)
    options = {
      headers: DEFAULT_HEADERS.merge({"Content-Type" => "application/x-www-form-urlencoded"}),
      body: { user: { account_id: 4, email: "#{email}", password: "#{password}" } }
    }
    @last_response =  handle_request { self.class.post("/auth/sign_up", options) }
    @user = handle_response(@last_response)
  end

  ### class Methods
  def self.sign_up(email, password)
    new(email, password, create: true)
  end

  def self.sign_in_or_sign_up(email, password)
    profinda = new(email, password)
    if profinda.api_token.nil?
      profinda = sign_up(email, password)
    end
    profinda
  end

  protected

    def authorized_headers
      token = user ? user.authentication_token : 'INvALIDTokeN'
      DEFAULT_HEADERS.merge({"PROFINDAAPITOKEN" => token })
    end

    ### PARSER MODULE
    def parse_data(data)
      return data unless data.is_a?(Hash)
      OpenStruct.new(data.with_indifferent_access)
    end

    ### REQUESTS MODULE
    def default_get_options
      { headers: authorized_headers, body: {} }
    end

    def default_post_options
      { headers: authorized_headers.merge({"Content-Type" => "application/json"}), body: {} }
    end

    def handle_request
      begin
        yield
      rescue Exception => e
        @valid = false
        errors.add(:base, e.message)
        nil
      end
    end

    def handle_response(response)
      if response.blank?
        nil
      else
        if response.success?
          @valid = true
          parse_data(response.parsed_response)
        else
          @valid = false
          add_errors_from_response(response)
          nil
        end
      end
    end

    def add_errors_from_response(response)
      response = response.parsed_response
      if response.has_key?("errors")
        response["errors"].each do |key, value|
          value.each do |message|
            errors.add(key.to_sym, message)
          end
        end
      elsif response.has_key?("message")
        errors.add(:base, response["message"])
      ##search more cases
      end
    end

    def get(url, options={})
      options = default_get_options.merge(options)
      @last_response = handle_request { self.class.get(url, options) }
      handle_response(@last_response)
    end

    def post(url, options={})
      options = default_post_options.merge(options)
      @last_response = handle_request { self.class.post(url, options) }
      handle_response(@last_response)
    end

    def put(url, options={})
      options = default_post_options.merge(options)
      @last_response = handle_request { self.class.put(url, options) }
      handle_response(@last_response)
    end

    def delete(url, options={})
      options = default_post_options.merge(options)
      @last_response = handle_request { self.class.delete(url, options) }
      handle_response(@last_response)
    end

end
