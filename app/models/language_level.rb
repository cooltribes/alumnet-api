class LanguageLevel < ActiveRecord::Base
  acts_as_paranoid

  ### Relations
  belongs_to :profile
  belongs_to :language

  ### Validations
  validates_inclusion_of :level, in: (1..5)

  ### Callbacks
  after_save :update_profinda_profile

  private

    def update_profinda_profile
      profile.user.save_profinda_profile if profile.user.active?
    end
end
