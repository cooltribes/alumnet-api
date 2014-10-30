require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:password).on(:create) }
  it { should have_many(:memberships) }
  it { should have_many(:groups).through(:memberships) }
  it { should have_many(:posts) }


  describe "callbacks" do
    it "should set a api_key on save" do
      user = User.make
      user.save
      expect(user.api_token).to_not be_blank
    end
  end
end
