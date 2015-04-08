class Like < ActiveRecord::Base
  acts_as_paranoid

  ### Ralations
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  ### Validations
  validates_uniqueness_of :user_id, scope: [:likeable_id, :likeable_type],
    message: "already made like!"
end
