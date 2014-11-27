require 'rails_helper'

describe V1::SkillsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /skills" do
    it "return all skills" do
      3.times { Skill.make! }
      get skills_path, {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end
end