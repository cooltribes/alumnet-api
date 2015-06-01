class Invitation < ActiveRecord::Base
  acts_as_paranoid

  ## Relations
  belongs_to :user
  belongs_to :guest, class_name: "User"

  ## Callbacks
  before_create :generate_token

  ## scopes
  scope :accepted, -> { where(accepted: true) }
  scope :unaccepted, -> { where(accepted: false) }


  ## class methods
  def self.mark_as_accepted(token, guest)
    return unless token.present?
    invitation = unaccepted.find_by(token: token)
    invitation.accept!(guest) if invitation
  end

  ## instance methods
  def accept!(guest)
    update_columns(accepted: true, guest_id: guest)
  end


  private

    def generate_token
      self[:token] = SecureRandom.urlsafe_base64(16).tr('lIO0', 'sxyz')
    end

end
