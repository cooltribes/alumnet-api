require 'rails_helper'

RSpec.describe Group, :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:cover) }
  # it { should validate_presence_of(:group_type) }

  it { should have_many(:memberships) }
  it { should have_many(:users).through(:memberships) }
  it { should have_many(:posts) }
  it { should belong_to(:country) }
  it { should belong_to(:city) }

end
