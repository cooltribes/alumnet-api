require 'rails_helper'

RSpec.describe Album, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:albumable) }
  it { should have_many(:pictures) }
  it "should set the date take" do
    album = Album.new
    album.date_taken = ""
    album.save
    expect(album.date_taken).to eq(Date.today)
  end

end
