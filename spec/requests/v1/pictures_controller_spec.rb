require 'rails_helper'

describe V1::PicturesController, type: :request do
  let!(:user) { User.make! }

  def picture_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/cover_test.jpg")
  end

  def valid_attributes
    { name: "picture_new.jpg", file: picture_file }
  end


  describe "GET /pictures" do
    before do
      3.times { Picture.make! }
    end

    it "return all pictures" do
      get pictures_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "GET /pictures/:id" do
    it "return a picture by id" do
      picture = Picture.make!
      get picture_path(picture), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('title')
      expect(json).to have_key('id')
    end
  end

  describe "POST /pictures" do
    context "with valid attributes" do
      it "create a picture and membership for user" do
        expect {
          post pictures_path, valid_attributes , basic_header(user.auth_token)
        }.to change(Picture, :count).by(1)
        expect(response.status).to eq 201
        expect(json['title']).to eq(Picture.last.title)
      end
    end
  end

  describe "PUT /pictures/1" do
    it "edit a picture" do
      picture = Picture.make!
      put picture_path(picture), { title: "New title picture" }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      picture.reload
      expect(json['title']).to eq("New title picture")
      expect(picture.title).to eq("New title picture")
    end
  end

  describe "DELETE /pictures/1" do
    it "delete a picture" do
      picture = Picture.make!
      expect {
        delete picture_path(picture), {}, basic_header(user.auth_token)
      }.to change(Picture, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end