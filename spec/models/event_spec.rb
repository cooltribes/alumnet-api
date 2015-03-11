require 'rails_helper'

RSpec.describe Event, :type => :model do
  it { should belong_to(:eventable) }
  it { should belong_to(:city) }
  it { should belong_to(:country) }
  it { should have_many(:attendances) }

end
