require 'rails_helper'

RSpec.describe Like, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:likeable) }

  it "should have paranoia" do
    expect(Like.paranoid?).to eq(true)
  end
end
