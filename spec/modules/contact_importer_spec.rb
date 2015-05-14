require 'rails_helper'

RSpec.describe ContactImporter do
  let(:importer) { ContactImporter.new("#{Rails.root}/spec/fixtures/contacts.csv") }

  describe "#contacts" do
    it "return all contact extracted from file" do
      expect(importer.contacts).to eq([
        {"name"=>"Armando Mendoza", "email"=>"fcoarmandomendoza@gmail.com"},
        {"name"=>"Flor Mendez", "email"=>"flor.maria.mendez@gmail.com"},
        {"name"=>"Cristal Montañez", "email"=>" cristalmontanez@gmail.com"}])
    end
  end

  describe "#count" do
    it "return the number of contacts in file" do
      expect(importer.count).to eq(3)
    end
  end

  describe "validations" do

    it { expect(importer).to be_valid }

    it "the file should have a header with 'name' and 'email' keys" do
      invalid_importer = ContactImporter.new("#{Rails.root}/spec/fixtures/contacts_without_header.csv")
      expect(invalid_importer).to_not be_valid
      expect(invalid_importer.errors[:headers]).to eq(["The format of header is not valid"])
    end

    it "the file should have a body content" do
      invalid_importer = ContactImporter.new("#{Rails.root}/spec/fixtures/contacts_without_body.csv")
      expect(invalid_importer).to_not be_valid
      expect(invalid_importer.errors[:count]).to eq(["The file no contain any contact"])
    end
  end

end