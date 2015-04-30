require 'rails_helper'

RSpec.describe OauthProvider, :type => :model do
  it { should belong_to(:user) }
end
