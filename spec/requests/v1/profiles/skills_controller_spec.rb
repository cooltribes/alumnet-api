require 'rails_helper'

describe V1::Profiles::SkillsController, type: :request do
  let!(:user) { User.make! }

  before do
    @profile = user.profile
  end

  describe "GET /profiles/:id/skills" do
    it "return all skills of profile" do
      3.times { @profile.skills << Skill.make! }
      get profile_skills_path(@profile), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /profiles/:id/skills" do
    it "create a new skill on given profile" do
      post profile_skills_path(@profile), { skill_names: ["Skill 1", "Skill 2"]} , basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.first["name"]).to eq("Skill 1")
    end
  end

  describe "DELETE /profiles/:id/skills/:id" do
    it "delete a skill" do
      skill = Skill.make!
      @profile.skills << skill
      expect {
        delete profile_skill_path(@profile, skill), {}, basic_header(user.auth_token)
      }.to change(@profile.skills, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end