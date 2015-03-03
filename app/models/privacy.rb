class Privacy < ActiveRecord::Base
  acts_as_paranoid

  ### Relations
  belongs_to :user
  belongs_to :privacy_action

  ### Validations
  validates :value, presence: true

  ### Instance Methods

  def description
    privacy_action.description
  end
end
