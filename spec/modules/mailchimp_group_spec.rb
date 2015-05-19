require 'rails_helper'

RSpec.describe MailchimpGroup, :type => :module do

  describe '#subscribe' do
    it 'should return true if the subcription is ok' do
      group = Group.make!(mailchimp: true, api_key: 'f0ad0e019703b02132b2cf15ad458e50-us10', list_id: "f3034576a5")
      user = User.make!
      mailchimp = MailchimpGroup.new(group)
      expect(mailchimp.subscribe(user)["email"]).to eq(user.email)
    end
  end

  describe '#validate' do
    context 'with valid api_key'
    it 'should be valid ' do
      group = Group.make!(mailchimp: true, api_key: 'f0ad0e019703b02132b2cf15ad458e50-us10', list_id: "f3034576a5" )
      mailchimp = MailchimpGroup.new(group)
      expect(mailchimp).to be_valid
    end

    context 'with invalid api_key'
    it 'should return an error' do
      group = Group.make!(mailchimp: true, api_key: 'skdajdk', list_id: "f3034576a5")
      mailchimp = MailchimpGroup.new(group)
      expect(mailchimp).to_not be_valid
      expect(mailchimp.errors[:api_key]).to eq(['Invalid API Key'])
    end

    context 'with without api_key'
    it 'should return an error' do
      group = Group.make(mailchimp: true)
      mailchimp = MailchimpGroup.new(group)
      expect(mailchimp).to_not be_valid
      expect(mailchimp.errors[:api_key]).to eq(['Group should have api key'])
    end
  end
end