require 'rails_helper'

describe V1::SenioritiesController, type: :request do
  let!(:current_user) { User.make! }
  let!(:admin) { User.make!(:admin) }

  describe "GET /seniorities" do
    it "return seniorities" do
      2.times { Seniority.make! }
      get seniorities_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "POST /seniorities" do
    context "with valid attributes" do
      context "User admin" do
        it "should create a seniorities" do
          expect {
            post seniorities_path, { name: "Senior", seniority_type: "Profesional" } , basic_header(admin.auth_token)
          }.to change(Seniority, :count).by(1)
          expect(response.status).to eq 201
          expect(Seniority.last.name).to eq("Senior")
        end
      end
      context "User regular" do
        it "should not create a seniorities" do
          expect {
            post seniorities_path, { name: "Senior", seniority_type: "Profesional" } , basic_header(current_user.auth_token)
          }.to change(Seniority, :count).by(0)
          expect(response.status).to eq 403
        end
      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post seniorities_path, { name: "Senior"  }, basic_header(admin.auth_token)
        }.to change(Seniority, :count).by(0)
        expect(json).to eq({"seniority_type"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /seniorities/:id" do
    context "User admin" do
      it "should update a seniority" do
        seniority = Seniority.make!
        put seniority_path(seniority), { seniority_type: "AIESEC"}, basic_header(admin.auth_token)
        seniority.reload
        expect(seniority.seniority_type).to eq("AIESEC")
      end
    end
    context "User regular" do
      it "should can't update a seniority" do
        seniority = Seniority.make!
        put seniority_path(seniority), { seniority_type: "AIESEC" }, basic_header(current_user.auth_token)
        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE /seniorities/:id" do
    context "User admin" do
      it "delete a seniority" do
        seniority = Seniority.make!
        expect {
          delete seniority_path(seniority), {}, basic_header(admin.auth_token)
        }.to change(Seniority, :count).by(-1)
        expect(response.status).to eq 204
      end
    end
  end
  context "User regular" do
    it "can't delete a seniority" do
      seniority = Seniority.make!
      expect {
        delete seniority_path(seniority), {}, basic_header(current_user.auth_token)
      }.to change(Seniority, :count).by(0)
      expect(response.status).to eq 403
    end
  end
end