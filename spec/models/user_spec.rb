require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:password).on(:create) }
  it { should have_many(:memberships) }
  it { should have_many(:groups).through(:memberships) }
  it { should have_many(:posts) }
  it { should have_many(:likes) }

  describe "callbacks" do
    it "should set a api_key on save" do
      user = User.make
      user.save
      expect(user.api_token).to_not be_blank
    end
  end

  describe "instance methods" do
    describe "has_like_in?(likeable)" do
      it "it return true if user has a like record in the likeable model" do
        post = Post.make!
        user = User.make!
        expect(user.has_like_in?(post)).to eq(false)
        Like.make!(user: user, likeable: post)
        expect(user.has_like_in?(post)).to eq(true)
      end
    end
  end

end
