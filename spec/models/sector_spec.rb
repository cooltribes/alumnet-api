require 'rails_helper'

RSpec.describe Sector, :type => :model do
  it { should have_many(:companies) }
end
