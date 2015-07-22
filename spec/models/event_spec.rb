require 'rails_helper'

RSpec.describe Event, :type => :model do
  it { should belong_to(:eventable) }
  it { should belong_to(:city) }
  it { should belong_to(:country) }
  it { should have_many(:attendances) }

  describe "Callbacks" do
    describe "#send_invites" do
      it "if invite_group_members is true then create attendances for all members of group" do
        group = Group.make!
        4.times { Membership.make!(:approved, group: group) }
        event = Event.make!(eventable: group, creator: User.first, invite_group_members: "true")
        event.group_members.each do |member|
          expect(member.attendance_for(event)).not_to be_nil
        end
      end
    end
  end

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

  describe "#user_can_upload_files?" do
    it "return true if user can upload file in event" do
      creator = User.make!
      event = Event.make!(eventable: creator, creator: creator, upload_files: 1)
      event.create_attendance_for(creator)
      # event.attendances.find_by(user: creator).going!
      expect(event.user_can_upload_files?(creator)).to eq(true)
      user = User.make!
      event.create_attendance_for(user)
      event.attendances.find_by(user: user).going!
      expect(event.user_can_upload_files?(user)).to eq(true)
    end
  end
end
