require 'rails_helper'

RSpec.describe Group, :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:cover) }
  it { should validate_presence_of(:join_process) }
  it { should validate_presence_of(:group_type) }

  it { should have_many(:memberships) }
  it { should have_many(:users).through(:memberships) }
  it { should have_many(:posts) }
  it { should belong_to(:country) }
  it { should belong_to(:city) }


  describe "Callbacks" do
    describe "check_join_process" do
      it "group is closed and join_process is 0 then change join_process to 2" do
        group = Group.make!
        expect(group.group_type).to eq("open") #open
        expect(group.join_process).to eq(0) #all can invite
        group.update(group_type: 1) #change to closed group
        expect(group.join_process).to eq(2) #only admin can invite
      end
      it "group is secret and join_process is 1 then change  join_process to 2" do
        group = Group.make!(group_type: 1, join_process: 1)
        expect(group.group_type).to eq("closed") #open
        expect(group.join_process).to eq(1) #all can invite, but admin approved
        group.update(group_type: 2) #change to secret group
        expect(group.join_process).to eq(2) #only admin can invite
      end
    end
  end
end
