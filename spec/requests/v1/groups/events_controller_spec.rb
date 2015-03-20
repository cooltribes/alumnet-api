require 'rails_helper'

describe V1::Groups::EventsController, type: :request do
  let!(:user) { User.make! }
  let!(:group) { Group.make! }
  let!(:country) { Country.make! }
  let!(:city) { country.cities.last }

  def cover_file
    fixture_file_upload("#{Rails.root}/spec/fixtures/cover_test.jpg")
  end

  def valid_attributes
    { name: "Event 1", description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, invitation_process: 0 }
  end

  def invalid_attributes
    { name: "", description: "short description", cover: cover_file,
      country_id: country.id, city_id: city.id, invitation_process: 0 }
  end


  describe "GET /groups/:group_id/events" do

    before do
      5.times { Event.make!(eventable: group)  }
    end

    it "return all events of group" do
      get group_events_path(group), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end
  end

  describe "GET /groups/:group_id/events/:id" do
    it "return a event of a group by id" do
      event = Event.make!(eventable: group)
      get group_event_path(group, event), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('name')
      expect(json).to have_key('description')
      expect(json).to have_key('created_at')
    end
  end

  describe "POST /groups/:group_id/events" do
    context "with valid attributes" do
      it "create a event in group" do
        expect {
          post group_events_path(group), valid_attributes , basic_header(user.auth_token)
        }.to change(Event, :count).by(1)
        expect(response.status).to eq 201
        event = group.events.last
        expect(event.name).to eq(valid_attributes[:name])
        expect(event.creator).to eq(user)
      end
    end

    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post group_events_path(group), invalid_attributes, basic_header(user.auth_token)
        }.to change(Event, :count).by(0)
        expect(json).to eq({"name"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /groups/:group_id/events/:id" do
    it "edit a event of group" do
      event = Event.make!(eventable: group)
      put group_event_path(group, event), { description: "New description of event" }, basic_header(user.auth_token)
      expect(response.status).to eq 200
      event.reload
      expect(event.description).to eq("New description of event")
    end
  end

  describe "DELETE /groups/:group_id/events/:id" do
    it "delete a event of group" do
      event = Event.make!(eventable: group)
      expect {
        delete group_event_path(group, event), {}, basic_header(user.auth_token)
      }.to change(Event, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end