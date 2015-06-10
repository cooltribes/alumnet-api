class Match < ActiveRecord::Base
  ## Relations
  belongs_to :task
  belongs_to :user

  ## scopes
  scope :applied, -> { where(applied: true) }
  scope :not_applied, -> { where(applied: false) }
end
