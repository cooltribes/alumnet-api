require 'rails_helper'

describe V1::ContactsController, type: :request do
  let!(:user) { User.make! }

  def contact_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/contacts.csv")
  end

  describe "POST /file" do
    it "return all valid contacts from file" do
      post contacts_file_me_path, { file: contact_file }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to eq({ "contacts" => [
        {"name"=>"Armando Mendoza", "email"=>"fcoarmandomendoza@gmail.com"},
        {"name"=>"Flor Mendez", "email"=>"flor.maria.mendez@gmail.com"},
        {"name"=>"Cristal Montañez", "email"=>" cristalmontanez@gmail.com"}]})
    end
  end

  describe "POST /in_alumnet" do
    it "return all users in alumnet that match with the contacts passed" do
      contacts = [
        {"name"=>"Armando Mendoza", "email"=>"fcoarmandomendoza@gmail.com"},
        {"name"=>"Flor Mendez", "email"=>"flor.maria.mendez@gmail.com"},
        {"name"=>"Cristal Montañez", "email"=>" cristalmontanez@gmail.com"}]
      User.make!(email: "fcoarmandomendoza@gmail.com")
      User.make!(email: "flor.maria.mendez@gmail.com")
      post contacts_in_alumnet_me_path, { contacts: contacts }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
      expect(json.first).to have_key("email")
      expect(json.first).to have_key("name")
    end
  end
end