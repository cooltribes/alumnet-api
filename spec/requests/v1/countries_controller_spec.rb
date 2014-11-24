require 'rails_helper'

describe V1::CountriesController, type: :request do
  let!(:user) { User.make! }

  describe "GET /countries" do
    it "return all countries" do
      3.times { Country.make! }
      get countries_path, {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /countries/:id" do
    it "return country by id" do
      country = Country.make!
      get country_path(country), {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json["name"]).to eq(country.name)
    end
  end

  describe "GET /countries/:id/cities" do
    it "return all cities of country" do
      country = Country.make!
      get cities_country_path(country), {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(country.cities.count)
    end
  end

  describe "GET /countries/:id/committees" do
    it "return all Committees of country" do
      country = Country.make!
      get committees_country_path(country), {}, basic_header(user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(country.committees.count)
    end
  end
end