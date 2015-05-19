require 'mailchimp'
class MailchimpGroup
  include ActiveModel::Model

  validate :presence_of_api_key, :check_valid_api_key, :check_list_id

  def initialize(group)
    @group = group
    if @group.mailchimp
      begin
        @mailchimp = Mailchimp::API.new(@group.api_key) if valid?
      rescue Mailchimp::InvalidApiKeyError
        @valid_api_key = false
      end
    end
  end


  def subscribe(user)
    @mailchimp.lists.subscribe(@group.list_id, {'email' => user.email}, nil, 'html', false, true, true, true)
    rescue Mailchimp::ListDoesNotExistError
      @list_id = false
  end

  def unsubscribe(user)
  end

  protected

  def check_list_id
    if @list_id == false
      errors.add(:api_key, 'List does not exist')
    end
  end

  def check_valid_api_key
    if @valid_api_key == false
      errors.add(:api_key, 'Invalid API Key')
    end
  end

  def presence_of_api_key
    unless @group.api_key
      errors.add(:api_key, 'Group should have api key')
    end
  end
end