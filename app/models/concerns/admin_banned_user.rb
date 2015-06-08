class AdminBannedUser
  include ActiveModel::Model

  attr_reader :user, :mailchimp

  validate :if_user_is_active, :if_mailchimp_has_errors

  def initialize(user, mailchimp)
    @user = user
    @mailchimp = mailchimp
    run
  end

  def run
    if user.active?
      banned_user
      mailchimp_process
    else
      @user_active = false
    end
  end

  private

    def banned_user
      user.banned!
      user.suspend_in_profinda
    end

    def mailchimp_process
      mailchimp.lists.unsubscribe(Settings.mailchimp_general_list_id, {'email' => user.email}, false, false, true)
      rescue Mailchimp::EmailNotExistsError
        @mailchimp_errors = true
    end

    def if_user_is_active
      errors.add(:user, "the user is already banned or inactive") if @user_active == false
    end

    def if_mailchimp_has_errors
      errors.add(:user, "mailchimp raise errors") if @mailchimp_errors
    end
end