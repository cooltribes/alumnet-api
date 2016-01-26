module Users
  class ActivateUser
    include ActiveModel::Model

    attr_reader :user

    def initialize(user, mailchimp)
      @user = user
      @mailchimp = mailchimp
    end

    def call
      unless user.active?
        activate_process
      else
        errors.add(:user, "is already activated")
        false
      end
    end

    private
      def activate_process
        if user.activate!
          user.switch_approval_to_friendship
          save_profile_and_activate_in_profinda
          ##TODO: Urgentemente refactorizar este metodo. :yondri
          user.subscribe_to_mailchimp_list(@mailchimp, Settings.mailchimp_general_list_id)
          true
        else
          errors.add(:user, "can't be activate")
          false
        end
      end

      def save_profile_and_activate_in_profinda
        user.save_profinda_profile unless user.profinda_uid.present?
        user.activate_in_profinda
      end
  end
end