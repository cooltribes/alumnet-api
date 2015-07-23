require 'rails_helper'

RSpec.describe Seniority, :type => :model do
  it { should have_many(:experiences) }
  it { should have_many(:tasks) }
end
