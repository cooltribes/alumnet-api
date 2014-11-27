require 'rails_helper'

RSpec.describe Profile, :type => :model do
  it { should validate_presence_of(:first_name).on(:update) }
  #it { should validate_presence_of(:last_name).on(:update) }
  it { should belong_to(:user) }
  it { should have_many(:contact_infos) }
  it { should have_many(:experiences) }
  it { should have_and_belong_to_many(:languages) }
  it { should have_and_belong_to_many(:skills) }



  describe "instances methods" do
    describe "#update_step" do
      it "should changed the register_step to next step" do
        user = User.make!
        profile = user.profile
        profile.update(first_name: "Armando", last_name: "Mendoza")
        expect(profile.register_step).to eq("initial")
        profile.update_step
        expect(profile.register_step).to eq("profile")
        profile.update_step
        expect(profile.register_step).to eq("contact")
        profile.update_step
        expect(profile.register_step).to eq("experience_a")
        profile.update_step
        expect(profile.register_step).to eq("experience_b")
        profile.update_step
        expect(profile.register_step).to eq("experience_c")
        profile.update_step
        expect(profile.register_step).to eq("experience_d")
        profile.update_step
        expect(profile.register_step).to eq("skills")
        profile.update_step
        expect(profile.register_step).to eq("approval")
      end
    end
  end
end