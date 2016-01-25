require 'mailchimp'
class Campaign < ActiveRecord::Base
	enum status: [:saved, :sent]

  belongs_to :group
  belongs_to :user

  def get_mailchimp_details
    @mailchimp = Mailchimp::API.new(self.group.api_key)
    @details = @mailchimp.campaigns.list({'campaign_id' => self.provider_id})
  end

  # def save_on_mailchimp(mailchimp, group)
  # 	mailchimp.campaigns.create('regular', 
  #     {
  #       'list_id' => group.list_id, 
  #       'subject' => self.subject, 
  #       'from_email' => 'yondri@gmail.com',
  #       'from_name' => 'Alumnet',
  #       'to_name' => group.name
  #     },
  #     {
  #       'html' => self.body
  #     }
  #   )
  # end

  # def send
  # 	mailchimp.campaigns.send_test(self.provider_id, ['yroa@upsidecorp.ch'])
  # end
end