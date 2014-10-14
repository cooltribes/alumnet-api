require 'rails_helper'

RSpec.describe Group, :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:avatar) }
  # it { should validate_presence_of(:group_type) }
end
