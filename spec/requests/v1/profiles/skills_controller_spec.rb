require 'rails_helper'

describe V1::Profiles::SkillsController, type: :request do
  let!(:user) { User.make! }
  let!(:other) { User.make! }

  def valid_attributes
    { "name" => "A new Skill" }
  end

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
      post profile_skills_path(@profile), valid_attributes , basic_header(user.auth_token)
      expect(response.status).to eq 201
      expect(json["name"]).to eq("A new Skill")
    end
  end

  describe "PUT /profiles/:id/skills/:id" do
    it "update an skill on given profile" do
      skill = Skill.make!
      @profile.skills << skill
      put profile_skill_path(@profile, skill), { name: "New Skill Name"} , basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq("New Skill Name")
    end
  end

  describe "DELETE /profiles/:id/skills/:id" do
    it "delete a skill" do
      skill = Skill.make!
      @profile.skills << skill
      expect {
        delete profile_skill_path(@profile, skill), {}, basic_header(user.auth_token)
      }.to change(Skill, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

  context "testing authorization" do
    describe "PUT /profiles/:id/skills/:id" do
      it "should not authorize the action" do
        skill = Skill.make!
        @profile.skills << skill
        put profile_skill_path(@profile, skill), { name: "New Skill Name"} , basic_header(other.auth_token)
        expect(response.status).to eq 403
      end
    end
  end
end