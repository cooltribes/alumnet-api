require 'rails_helper'

RSpec.describe ContactInfo, :type => :model do
  it { should belong_to(:profile) }
end
