require 'rails_helper'

RSpec.describe UserAction, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:action) }
end