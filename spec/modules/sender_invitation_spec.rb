require 'rails_helper'

RSpec.describe SenderInvitation do
  let!(:user_sender) { User.make! }

  describe "contacts" do
    describe "when an Array is passed" do
      it "return the array with the keys of contacts converted in symbol" do
        contacts_array = [{"name" => "name_one", "email" => "testing@email.com"}]
        sender = SenderInvitation.new(contacts_array, user_sender)
        expect(sender.contacts).to eq([{name: "name_one", email: "testing@email.com"}])
      end
    end
    describe "when an Hash is passed" do
      it "return the array with values of hash with the keys of contacts converted in symbol" do
        contacts_hash = {contacts_one: {"name" =>  "text", "email" => "testing@email.com"}}
        sender = SenderInvitation.new(contacts_hash, user_sender)
        expect(sender.contacts).to eq([{name: "text", email: "testing@email.com"}])
      end
    end
  end

  describe "contacts_out_alumnet" do
    it "return an array of contacts which not exists in Alumnet's users" do
      contacts_array = [
        {"name" => "name_one", "email" => "testing@email.com"},
        {"name" => "name_two", "email" => "testing2@email.com"}
      ]
      sender = SenderInvitation.new(contacts_array, user_sender)
      expect(sender.contacts_out_alumnet).to eq([
        {name: "name_one", email: "testing@email.com"},
        {name: "name_two", email: "testing2@email.com"}
      ])
      User.make!(email: "testing@email.com")
      expect(sender.contacts_out_alumnet).to eq([{name: "name_two", email: "testing2@email.com"}])
    end
  end

  describe "contacts_in_alumnet" do
    it "return an array of contacts which not exists in Alumnet's users" do
      contacts_array = [
        {"name" => "name_one", "email" => "testing@email.com"},
        {"name" => "name_two", "email" => "testing2@email.com"}
      ]
      sender = SenderInvitation.new(contacts_array, user_sender)
      expect(sender.contacts_in_alumnet).to eq([])
      user = User.make!(email: "testing@email.com")
      expect(sender.contacts_in_alumnet).to eq([{name: user.name, email: "testing@email.com"}])
    end
  end

  describe "send_invitations" do
    pending "Test mailer queqe"
    # it "should send email to contacts extracted" do
    #   sender = SenderInvitation.new({contacts_one: {"name" =>  "text", "email" => "testing@email.com"}}, user_sender)
    #   sender.send_invitations
    #   expect(ActionMailer::Base.deliveries).to_not be_empty
    # end

    it "should create an invitation" do
      sender = SenderInvitation.new({contacts_one: {"name" =>  "text", "email" => "testing@email.com"}}, user_sender)
      expect {
        sender.send_invitations
      }.to change(Invitation, :count).by(1)
      invitation = Invitation.last
      expect(invitation.guest_email).to eq("testing@email.com")
      expect(invitation).to_not be_accepted
      expect(invitation.user).to eq(user_sender)
      expect(invitation.token).to_not be_empty
      end
  end

  describe "validations" do
    it "should return an error if the contacts are empty" do
      sender = SenderInvitation.new([], user_sender)
      expect(sender).to_not be_valid
      expect(sender.errors[:base]).to eq(["The contacts are empty"])
    end
    it "should return an error if the contacts not have name and email keys" do
      sender = SenderInvitation.new([{nombre: "name", mail: "testing@email"}], user_sender)
      expect(sender).to_not be_valid
      expect(sender.errors[:base]).to eq(["Contacts with bad format. Please check the data"])
    end
  end
end