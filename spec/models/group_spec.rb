require 'rails_helper'

RSpec.describe Group, :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:cover) }
  # it { should validate_presence_of(:group_type) }

  it { should have_many(:memberships) }
  it { should have_many(:users).through(:memberships) }
  it { should have_many(:posts) }


  describe "instance methods" do
    describe "#members" do
      it "return all users with membership on group which are approved" do
        group = Group.make!
        creator = User.make!
        Membership.create_membership_for_creator(group, creator)
        user_one = User.make!
        Membership.create_membership_for_request(group, user_one)
        user_two = User.make!
        Membership.create_membership_for_request(group, user_two)
        user_three = User.make!
        Membership.create_membership_for_invitation(group, user_three)
        user_four = User.make!
        Membership.create_membership_for_invitation(group, user_four)
        expect(group.members.to_a).to match_array([creator, user_one, user_two])
      end
    end
  end


end
