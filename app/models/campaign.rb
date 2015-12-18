class Campaign < ActiveRecord::Base
	enum status: [:saved, :sent]

  belongs_to :group
  belongs_to :user

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
