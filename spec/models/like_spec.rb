require 'rails_helper'

RSpec.describe Like, :type => :model do
  it { should validate_uniqueness_of(:user_id).scoped_to([:likeable_id, :likeable_type]).
    with_message("already made like!") }

  it { should belong_to(:user) }
  it { should belong_to(:likeable) }
end
