require 'rails_helper'

describe V1::EventsController, type: :request do
  let!(:user) { User.make! }
  let!(:group) { Group.make! }

  describe "GET /groups/:group_id/events/:id" do
    it "return a event of a group by id" do
      event = Event.make!(eventable: group)
      get event_path(event), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json).to have_key('name')
      expect(json).to have_key('description')
      expect(json).to have_key('created_at')
    end
  end

end