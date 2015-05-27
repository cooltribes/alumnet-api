require 'rails_helper'

RSpec.describe BusinessInfo, :type => :model do
  it { should belong_to(:profile) }
end
