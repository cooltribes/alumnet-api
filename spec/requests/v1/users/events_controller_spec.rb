require 'rails_helper'

describe V1::Users::EventsController, type: :request do
  let!(:user) { User.make! }
  let!(:country) { Country.make! }
  let!(:city) { country.cities.last }

  def cover_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/cover_test.jpg")
  end

  def valid_attributes
    { name: "Event 1", description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, invitation_process: 0, start_date: Date.today,
      end_date: (Date.today + 10) }
  end

  def invalid_attributes
    { name: "", description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, invitation_process: 0, start_date: Date.today,
      end_date: (Date.today + 10) }
  end


  describe "GET /users/:user_id/events" do

    before do
      5.times do
        event = Event.make!(eventable: user)
        event.create_attendance_for(user)
      end
    end

    it "return all events of user" do
      get user_events_path(user), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end
  end

  describe "GET /users/:user_id/events/:id" do
    it "return a event of a user by id" do
      event = Event.make!(eventable: user, creator: user)
      get user_event_path(user, event), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('name')
      expect(json).to have_key('description')
      expect(json).to have_key('created_at')
    end
  end

  describe "POST /users/:user_id/events" do
    context "with valid attributes" do
      it "create a event in user" do
        expect {
          post user_events_path(user), valid_attributes , basic_header(user.auth_token)
        }.to change(Event, :count).by(1)
        expect(response.status).to eq 201
        event = user.events.last
        expect(event.name).to eq(valid_attributes[:name])
        expect(event.creator).to eq(user)
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post user_events_path(user), invalid_attributes, basic_header(user.auth_token)
        }.to change(Event, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /users/:user_id/events/:id" do
    it "edit a event of user" do
      event = Event.make!(eventable: user, creator: user)
      put user_event_path(user, event), { description: "New description of event" }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      event.reload
      expect(event.description).to eq("New description of event")
    end
  end

  describe "DELETE /users/:user_id/events/:id" do
    context "without payments" do
      it "delete a event of user" do
        event = Event.make!(eventable: user)
        expect {
          delete user_event_path(user, event), {}, basic_header(user.auth_token)
        }.to change(Event, :count).by(-1)
        expect(response.status).to eq 204
      end
    end
    context "with payments" do
      pending "ask to yondri"
      # it "dont delete the event and return a message" do
      #   event = Event.make!(eventable: user)
      #   EventPayment.make!(event: event)
      #   expect {
      #     delete user_event_path(user, event), {}, basic_header(user.auth_token)
      #   }.to change(Event, :count).by(0)
      #   expect(response.status).to eq 409
      #   expect(json['message']).to eq ('the event have orders')
      # end
    end
  end
end