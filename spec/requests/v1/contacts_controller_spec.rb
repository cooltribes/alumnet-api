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
end