require 'rails_helper'

RSpec.describe Action, :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:value) }
end
