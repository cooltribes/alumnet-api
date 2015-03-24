require 'rails_helper'

RSpec.describe Album, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:albumable) }
  it { should have_many(:pictures) }
 
end
