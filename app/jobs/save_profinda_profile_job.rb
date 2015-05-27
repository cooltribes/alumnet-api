class SaveProfindaProfileJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    profinda_api = ProfindaApi.sign_in_or_sign_up(user.email, user.profinda_password)
    if profinda_api.valid?
      user.set_profinda_uid = profinda_api.user['id']
      profinda_api.profile = user.info_for_profinda_registration
    end
  end
end