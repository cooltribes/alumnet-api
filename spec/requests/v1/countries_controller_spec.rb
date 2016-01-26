require 'rails_helper'

describe V1::CountriesController, type: :request do
  let!(:user) { User.make! }

  describe "GET /countries" do
    it "return all countries" do
      3.times { Country.make! }
      get countries_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5) #+2 of bluprint of user
    end
  end

  describe "GET /countries/locations" do
    it "return all countries and cities " do
      Country.make!(:simple, name: "Venezuela")
      get locations_countries_path, { q: { name_cont: "Vene"} }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(4) #+2 of bluprint of user
    end
  end

  describe "GET /countries/:id" do
    it "return country by id" do
      country = Country.make!
      get country_path(country), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq(country.name)
    end
  end

  describe "GET /countries/:id/cities" do
    it "return all cities of country" do
      country = Country.make!
      get cities_country_path(country), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(country.cities.count)
    end
  end

  describe "GET /countries/:id/committees" do
    it "return all Committees of country" do
      # Create "other" committee
      Committee.create(name: "Other")
      country = Country.make!
      get committees_country_path(country), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(country.committees.count + 1) #the other committee
    end
  end
end