require 'rails_helper'

RSpec.describe Attachment, :type => :model do
  it { should belong_to(:uploader) }
  it { should belong_to(:folder) }
end
