require 'rails_helper'

describe V1::Me::EventsController, type: :request do
  let!(:current_user) { User.make! }

  describe "GET /me/events/managed" do
    it "should return all groups where the current user is the creator" do
      #Se puede ser admin de un evento si se es admin del grupo
      1.times do
        group = Group.make!(creator: current_user)
        Membership.create_membership_for_creator(group, current_user)
        Event.make!(eventable: group)
      end
      Event.make!(eventable: current_user, creator: current_user, name: "Escape from Alcatraz")

      get managed_events_me_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json["data"].count).to eq(2)
    end
  end
end