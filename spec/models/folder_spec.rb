require 'rails_helper'

RSpec.describe Folder, :type => :model do
  it { should belong_to(:creator) }
  it { should belong_to(:folderable) }
  it { should have_many(:attachments) }
end
