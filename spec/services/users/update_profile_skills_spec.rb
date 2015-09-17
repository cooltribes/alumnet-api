require 'rails_helper'

RSpec.describe Users::UpdateProfileSkills, type: :service do

  it "should update the skills in profile and create new skill if not exists" do
    skill_names = ["Skill 1", "Skill 2", "Skill 3"]
    user = User.make!
    service = Users::UpdateProfileSkills.new(user.profile, skill_names)
    expect(Skill.count).to eq(0)
    expect(service.call).to eq(true)
    expect(Skill.count).to eq(3)
    expect(user.profile.skills.count).to eq(3)
    ##update skill in user
    skill_names = ["Skill 3"]
    service = Users::UpdateProfileSkills.new(user.profile, skill_names)
    expect(service.call).to eq(true)
    expect(Skill.count).to eq(3)
    expect(user.profile.skills.count).to eq(1)
  end

end