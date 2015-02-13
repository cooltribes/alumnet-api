require 'rails_helper'

RSpec.describe Membership, :type => :model do
  it { should belong_to(:group) }
  it { should belong_to(:user) }

  describe "callbacks" do

    describe "set admin" do
      it "set admin to true if any permissions attributes is greater than 0" do
        membership = Membership.make!(:not_approved)
        expect(membership.admin).to eq(false)
        membership.edit_group = 1
        membership.save
        expect(membership.admin).to eq(true)
        membership.edit_group = 0
        membership.save
        expect(membership.admin).to eq(false)
      end
    end
  end
end
