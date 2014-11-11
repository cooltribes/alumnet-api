require 'rails_helper'

RSpec.describe Friendship, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:friend) }


  describe "Instance Methods" do
    describe "#my_friends" do
      it "return all friends of user" do
        user = User.make!
        friend_one = User.make!
        friend_two = User.make!
        friend_three = User.make!
        user.add_to_friends(friend_one).accept!.save
        user.add_to_friends(friend_two).accept!.save
        friend_three.add_to_friends(user).accept!.save ##inverse_friend
        expect(user.my_friends).to match_array([friend_one, friend_two, friend_three])
      end
    end
  end

  describe "Custom validations" do
    describe "existence_of_friendship" do
      it "should be invalid if the friendship already exists" do
        user = User.make!
        friend = User.make!
        friendship = user.add_to_friends(friend)
        expect(friendship).to be_valid
        friendship.save
        expect(friendship).to be_invalid
        expect(friendship.errors[:friend_id]).to eq(["the user is your friend already"])
        reverse_friendship = friend.add_to_friends(user)
        expect(reverse_friendship).to be_invalid
        expect(reverse_friendship.errors[:friend_id]).to eq(["the user is your friend already"])
      end
    end
  end
end
