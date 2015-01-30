require 'rails_helper'

RSpec.describe Region, :type => :model do
  it { should  have_and_belong_to_many(:countries) }
end
