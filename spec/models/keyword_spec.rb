require 'rails_helper'

RSpec.describe Keyword, :type => :model do
  it { should  have_many(:company_relations) }
end
