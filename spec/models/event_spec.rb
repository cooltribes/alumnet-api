require 'rails_helper'

RSpec.describe Event, :type => :model do
  it { should belong_to(:eventable) }
  it { should belong_to(:city) }
  it { should belong_to(:country) }
  it { should have_many(:attendances) }

  describe "#group_admins" do
    it "return the group admins if belong to a group" do
      group = Group.make!
      3.times { Membership.make!(:approved, group: group, admin: true) }
      expect(group.admins.count).to eq(3)
      event = Event.make!(eventable: group)
      expect(event.group_admins).to eq(group.admins)
    end
  end
  describe "#is_admin?(user)" do
    it "return true if user is admin of event" do
      group = Group.make!
      user = User.make!
      event = Event.make!(eventable: group, creator: user)
      3.times { Membership.make!(:approved, group: group, admin: true) }
      expect(event.is_admin?(user)).to eq(true)
      user_group = group.admins.last
      expect(event.is_admin?(user_group)).to eq(true)
      other_user = User.make!
      expect(event.is_admin?(other_user)).to eq(false)
    end
  end
end
