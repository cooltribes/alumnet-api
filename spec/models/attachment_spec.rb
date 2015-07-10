require 'rails_helper'

RSpec.describe Attachment, :type => :model do
  it { should belong_to(:uploader) }
  it { should belong_to(:folder) }

  context "one copy" do
    before { @folder = Folder.make! }
    it "save the record with the name plus (1)" do
      original_attachment = Attachment.make!(name: "file_name.jpg", folder: @folder)
      new_attachement = Attachment.make(name: "file_name.jpg", folder: @folder)
      new_attachement.save
      expect(new_attachement.name).to eq("file_name(1).jpg")
    end
  end

  # context "many copies" do
  #   it "save the record with the name plus (x)" do
  #   end
  # end
end
