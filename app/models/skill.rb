class Skill < ActiveRecord::Base
  ### Relations
  has_and_belongs_to_many :profiles

  ### Callbacks
  before_save :update_profinda_profile

  private

    def update_profinda_profile
      profile.user.save_profinda_profile if profile.user.active?
    end
end
