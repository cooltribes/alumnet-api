require 'rails_helper'

RSpec.describe Profile, :type => :model do
  it { should validate_presence_of(:first_name).on(:update) }
  it { should validate_presence_of(:last_name).on(:update) }
  it { should belong_to(:user) }

end
