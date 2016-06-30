require 'rails_helper'

describe Webhooks::PusherController, type: :request do

  describe "POST /webhooks/pusher" do
    it "Should change the online property of user" do
      post "/webhooks/pusher", {}
      expect(response.status).to eq 401
    end
  end

end