require 'rails_helper'

RSpec.describe Region, :type => :model do
  it { should have_many(:countries) }
end
