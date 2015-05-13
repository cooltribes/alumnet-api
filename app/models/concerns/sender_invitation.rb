class SenderInvitation
  include ActiveModel::Model

  attr_reader :file, :count
  validate :contacts_format

  def initialize(contacts, sender)
    @count = 0
    @sender = sender
    if contacts.is_a?(Array)
      @contacts = contacts
    elsif contacts.is_a?(Hash)
      @contacts = extract_contact_from_hash(contacts)
    else
      @contacts = []
    end
  end

  def send_invitations
    contacts_out_alumnet.each do |contact|
      @count = count + 1
      UserMailer.invitation_to_alumnet(contact[:email], contact[:name], @sender).deliver
    end
  end

  def contacts
    @contacts.map(&:symbolize_keys)
  end

  def users_in_alumnet
    emails = extract_email_from_contacts(contacts)
    User.where(email: emails)
  end

  def contacts_in_alumnet
    contacts_array = []
    users_in_alumnet.each do |user|
      contacts_array << { name: user.name, email: user.email }
    end
    contacts_array
  end

  def contacts_out_alumnet
    contacts_array = []
    contacts.each do |contact|
      contacts_array << contact unless User.find_by(email: contact[:email])
    end
    contacts_array
  end

  protected
    def extract_email_from_contacts(contacts)
      contacts.inject([]) { |array, contact| array << contact[:email]  }
    end

    def extract_contact_from_hash(contacts)
      contacts.values
    end

    def contacts_format
      errors.add(:base, 'The contacts are empty') if contacts.empty?
      errors.add(:base, 'Contacts with bad format. Please check the data') unless contacts.all? { |c| c.has_key?(:email) && c.has_key?(:name) }
    end
end