require 'rails_helper'

RSpec.describe Language, :type => :model do
  it { should have_many(:language_levels) }
  it { should have_many(:profiles) }
end
