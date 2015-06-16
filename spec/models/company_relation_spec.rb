require 'rails_helper'

RSpec.describe CompanyRelation, :type => :model do
  it { should belong_to(:company) }
  it { should belong_to(:profile) }
  it { should have_many(:keywords) }
  it { should have_many(:links) }
  it { should validate_presence_of(:offer) }
  it { should validate_presence_of(:search) }


end
