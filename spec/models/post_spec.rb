require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:postable) }
end
