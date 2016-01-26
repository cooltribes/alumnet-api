require 'rails_helper'

RSpec.describe Global::SearchLocation, type: :service do

  before do
    #this blueprint create 3 cities with name "CityX of Venezuela"
    Country.make!(:simple, name: "Venezuela")
    Country.make!(:simple, name: "Argentina")
  end

  it "should search a countries and cities by params" do
    service = Global::SearchLocation.new("Vene")
    expect(service.call.count).to eq(4)
  end

end