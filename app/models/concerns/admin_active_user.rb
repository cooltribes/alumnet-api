class AdminActiveUser
  include ActiveModel::Model

  attr_reader :user, :mailchimp

  validate :if_user_is_active, :activate_errors

  def initialize(user, mailchimp)
    @user = user
    @mailchimp = mailchimp
    run
  end

  def run
    if user.active?
      @user_active = true
    else
      activate_user
    end
  end

  private

    def activate_user
      if user.activate!
        profinda_process
        user.subscribe_to_mailchimp_list(mailchimp, Settings.mailchimp_general_list_id)
      else
        @activate_errors = true
      end
    end

    def profinda_process
      user.save_profinda_profile unless user.profinda_uid.present?
      user.activate_in_profinda
    end

    def if_user_is_active
      errors.add(:user, "the user is already activated") if @user_active
    end

    def activate_errors
      errors.add(:user, "the register is incompleted!") if @activate_errors
    end
end