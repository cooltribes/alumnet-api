require 'rails_helper'

RSpec.describe Committee, :type => :model do
  it { should belong_to(:country) }
end
