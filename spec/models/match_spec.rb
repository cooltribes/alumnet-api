require 'rails_helper'

RSpec.describe Match, :type => :model do
  it { should belong_to(:task) }
  it { should belong_to(:user) }
end
