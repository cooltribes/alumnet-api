require 'rails_helper'

RSpec.describe Global::SearchLocation, type: :service do

  before do
    #this blueprint create 3 cities with name "CityX of Venezuela"
    Country.make!(:simple, name: "Venezuela")
  end

  it "should search a countries and cities by params" do
    params = { name_cont: "Vene" }
    service = Global::SearchLocation.new(params)
    expect(service.call.count).to eq(4)
  end

end