class CompanyAdmin < ActiveRecord::Base

  enum status: [:sent, :accepted]

  ### Relations
  belongs_to :user
  belongs_to :company

  ### Scopes
  scope :accepted, -> { where(status: 1) }
  scope :sent, -> { where(status: 0) }

  ### Validations
  validates_presence_of :user_id, :company_id

  ### Instance Methods

  def mark_as_accepted_by(user)
    update_columns(status: 1, accepted_by: user.id)
  end

end
