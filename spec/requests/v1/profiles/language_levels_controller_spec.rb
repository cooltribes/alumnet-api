require 'rails_helper'

describe V1::Profiles::LanguageLevelsController, type: :request do
  let!(:user) { User.make! }
  let!(:other) { User.make! }

  before do
    @profile = user.profile
    @language = Language.make!
    @language_level = LanguageLevel.create!(language_id: @language.id, level: 5, profile_id: @profile.id)
  end

  describe "GET /profiles/:id/language_levels" do
    it "return all languages of profile" do
      3.times do
        language = Language.make!
        @profile.language_levels << LanguageLevel.new(language_id: language.id, level: 5)
      end
      get profile_language_levels_path(@profile), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(4)
    end
  end

  describe "POST /profiles/:id/language_levels" do
    it "create a new language on given profile" do
      language = Language.make!
      post profile_language_levels_path(@profile), {"language_id" => language.id, "level" => 3}, basic_header(user.auth_token)
      expect(response.status).to eq 201
      expect(json["language_id"]).to eq(language.id)
      expect(json["level"]).to eq(3)
    end
  end

  describe "PUT /profiles/:id/language_levels/:id" do
    it "update an language on given profile" do
      put profile_language_level_path(@profile, @language_level), { "level" => 1} , basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["level"]).to eq(1)
      expect(json["language_id"]).to eq(@language.id)
    end
  end

  describe "DELETE /profiles/:id/language_levels/:id" do
    it "delete a language" do
      expect {
        delete profile_language_level_path(@profile, @language_level), {}, basic_header(user.auth_token)
      }.to change(LanguageLevel, :count).by(-1)
      expect(response.status).to eq 204
    end
  end

  context "testing authorization" do
    describe "PUT /profiles/:id/language_levels/:id" do
      it "should not authorize the action" do
        put profile_language_level_path(@profile, @language_level), { "level" => 3 } , basic_header(other.auth_token)
        expect(response.status).to eq 403
      end
    end
  end
end