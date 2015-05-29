class Invitation < ActiveRecord::Base
  acts_as_paranoid

  ## Relations
  belongs_to :user
  belongs_to :guest, class_name: "User"

  ## Callbacks
  before_create :generate_token

  def accept!
    update_column(:accepted, true)
  end


  private

    def generate_token
      self[:token] = SecureRandom.urlsafe_base64(16).tr('lIO0', 'sxyz')
    end

end
