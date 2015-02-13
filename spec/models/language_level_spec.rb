require 'rails_helper'

RSpec.describe LanguageLevel, :type => :model do
  it { should validate_inclusion_of(:level).in_range(1..5) }
end
