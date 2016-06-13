require 'rails_helper'

describe V1::AuthController, type: :request do
  let!(:user) { User.make!(password: "12345678A") }

  def header
    { 'Accept' => 'application/vnd.alumnet+json;version=1' }
  end

  def valid_attributes
    { user: { email: "test_email@gmail.com", password: "12345678A", password_confirmation: "12345678A" } }
  end

  def invalid_attributes
    { user: { email: "", password: "12345678A", password_confirmation: "12345678A" } }
  end

  describe "POST /sign_in" do
    context "with valid credentials" do
      it "return the user" do
        post sign_in_path, { email: user.email, password: "12345678A" }, header
        expect(response.status).to eq 200
        expect(json).to eq({"id"=>user.id, "email"=>user.email, "auth_token"=>user.auth_token,
          "name"=>user.name })
      end

      it "increment the sign_in counter" do
        expect(user.sign_in_count).to eq(0)
        post sign_in_path, { email: user.email, password: "12345678A" }, header
        user.reload
        expect(user.sign_in_count).to eq(1)
      end
    end

    context "with invalid credentials" do
      it "return the user" do
        post sign_in_path, { email: user.email, password: "123456dd78" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"email or password are incorrect"})
      end
    end

    context "without credentials" do
      it "return the user" do
        post sign_in_path, {}, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"Please enter your email address and your password"})
      end
    end
  end

  describe "POST /oauth_sign_in" do
    context "with valid credentials" do
      it "return the user" do
        provider = OauthProvider.make!(:facebook, user: user)
        post oauth_sign_in_path, { email: user.email, provider: provider.provider, uid: provider.uid }, header
        expect(response.status).to eq 200
        expect(json).to eq({"id"=>user.id, "email"=>user.email, "auth_token"=>user.auth_token,
          "name"=>user.name })
      end
    end

    context "with invalid credentials" do
      it "return the user" do
        post sign_in_path, { email: user.email, password: "123456dd78" }, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"email or password are incorrect"})
      end
    end

    context "without credentials" do
      it "return the user" do
        post sign_in_path, {}, header
        expect(response.status).to eq 401
        expect(json).to eq({"error"=>"Please enter your email address and your password"})
      end
    end
  end

  describe "POST /register" do
    context "with valid attributes" do
      it "create a user" do
        expect {
          post register_path, valid_attributes, header
        }.to change(User, :count).by(1)
        expect(response.status).to eq 201
        expect(json['email']).to eq("test_email@gmail.com")
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post register_path, invalid_attributes, header
        }.to change(User, :count).by(0)
        expect(json).to eq({"errors" => { "email"=>["can't be blank", "Please enter a valid e-mail address"] }})
        expect(response.status).to eq 422
      end
    end

    context "with invitation token" do
      it "create a user and mark the invitation as accepted" do
        invitation = Invitation.make!
        Action.make!(key_name: "accepted_invitation")
        valid_attributes_with_token = valid_attributes.merge({ invitation_token: invitation.token })
        expect {
          post register_path, valid_attributes_with_token , header
        }.to change(User, :count).by(1)
        expect(response.status).to eq 201
        expect(json['email']).to eq("test_email@gmail.com")
        invitation.reload
        expect(invitation).to be_accepted
        expect(invitation.guest).to eq(User.last) #be_present
      end
    end
  end

  describe "POST /mobile_register" do
    let(:city) { City.make!(:with_country) }
    let(:committee) { Committee.make! }

    let(:valid_mobile_params) do
      {
        user: { password: "FAMG12345678", email: "test_email@gmail.com" },
        # profile: { first_name: "Armando", last_name: "Mendoza", born: "1980-08-21", residence_city_id: city.id },
        experience: { start_date: "01-01-1995", end_date: "01-01-1996", country_id: city.country.id, committee_id: committee.id }
      }

    end

    let(:invalid_mobile_params) do
      {
        user: { password: "12345678", email: "test_email@gmail.com" },
        # profile: { first_name: "Armando", last_name: "Mendoza", born: "2006-08-26", residence_city_id: city.id },
        experience: { start_date: "01-01-1995", end_date: "01-01-1996", country_id: city.country.id, committee_id: committee.id }
      }
    end

    context "with valid attributes" do
      it "create a user" do
        expect {
          post mobile_register_path, valid_mobile_params, header
        }.to change(User, :count).by(1)
        expect(response.status).to eq 201
        expect(json['email']).to eq("test_email@gmail.com")
        user = User.last
        # expect(user.profile.last_name).to eq("Mendoza")
        # expect(user.profile.residence_country).to eq(city.country)
        experience = user.profile.experiences.last
        expect(experience.exp_type).to eq(1)
        expect(experience.committee).to eq(committee)
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post mobile_register_path, invalid_mobile_params, header
        }.to change(User, :count).by(0)
        expect(json).to eq( {"errors"=>[["Password must be a combination of numbers and letters"]]} )
        expect(response.status).to eq 422
      end
    end
  end
end