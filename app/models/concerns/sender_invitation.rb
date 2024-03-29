class SenderInvitation
  include ActiveModel::Model

  attr_reader :file, :count
  validate :contacts_format

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

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
      if is_valid_contact_email?(contact[:email])
        @count = count + 1
        invitation = Invitation.find_or_create_by(user: @sender, guest_email: contact[:email])
        #UserMailer.invitation_to_alumnet(contact[:email], contact[:name], @sender, invitation.token).deliver_later
        mailer = GeneralMailer.new
        mailer.invitation_to_alumnet(contact[:email], contact[:name], @sender, invitation.token)
      end
    end
  end

  def contacts
    strip_contacts_values(@contacts)
  end

  def users_in_alumnet
    emails = extract_email_from_contacts(contacts)
    User.active.where(email: emails)
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
      contacts_array << contact unless User.active.find_by(email: contact[:email])
    end
    contacts_array
  end

  protected
    # TODO: Add bad emails to errors and show :armando
    def is_valid_contact_email?(email)
      email.present? && email.strip =~ VALID_EMAIL_REGEX
    end

    def extract_email_from_contacts(contacts)
      contacts.inject([]) { |array, contact| array << contact[:email] }
    end

    def extract_contact_from_hash(contacts)
      contacts.values
    end

    def strip_contacts_values(contacts_array)
      new_contacts = []
      contacts_array.each do |contact|
        new_contact = contact.each_with_object({}) { |(k, v), hash| hash[k] = v.try(:strip) }
        new_contacts << new_contact
      end
      new_contacts.map(&:symbolize_keys)
    end

    def contacts_format
      errors.add(:base, 'The contacts are empty') if contacts.empty?
      errors.add(:base, 'Contacts with bad format. Please check the data') unless contacts.all? { |c| c.has_key?(:email) && c.has_key?(:name) }
    end
end