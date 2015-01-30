require 'rails_helper'

RSpec.describe Country, :type => :model do
  it { should  have_and_belong_to_many(:regions) }
  it { should have_many(:cities) }
  it { should have_many(:committees) }
  it { should have_many(:groups) }
end