require 'rails_helper'

RSpec.describe Profile, :type => :model do
  it { should validate_presence_of(:first_name).on(:update) }
  it { should validate_inclusion_of(:gender).in_array(["M", "F"]).on(:update) }
  it { should belong_to(:user) }
  it { should have_many(:contact_infos) }
  it { should have_many(:experiences) }
  it { should have_many(:language_levels) }
  it { should have_many(:languages) }
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

  describe "accept languages attributes" do
    it "should create a languages to profile" do
      language_one = Language.make!
      language_two = Language.make!
      user = User.make!
      profile = user.profile
      languages_attributes = { languages_attributes: [
        { "language_id"=> language_one.id, "level" => 5 },
        { "language_id"=> language_two.id, "level" => 3 }
      ]}
      profile.update(languages_attributes)
      expect(profile.languages.pluck(:name)).to match_array([language_one.name, language_two.name])
    end
  end

  describe "accept skills attributes" do
    it "should create a languages to profile" do
      skill = Skill.make!
      user = User.make!
      profile = user.profile
      skills_attributes = { skills_attributes: [
        "No Existe", skill.name
      ]}
      profile.update(skills_attributes)
      expect(profile.skills.pluck(:name)).to match_array(["No Existe", skill.name])
    end
  end

  describe "Validations" do
    it "valid that user should have more then 20 years" do
      user = User.make!
      profile = user.profile
      profile = Profile.make(born: "2010-01-01")
      profile.save
      expect(profile.errors[:born]).to eq(["You must have more than 20 years"])
      profile = Profile.make(born: "1980-01-01")
      profile.save
      expect(profile.errors.count).to eq(0)
    end
  end
end