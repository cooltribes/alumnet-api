require 'rails_helper'

describe V1::Users::SubscriptionsController, type: :request do
  let!(:user) { User.make! }
  let!(:subscription) { Subscription.make!(:premium)}

  describe "GET /users/:user_id/subscriptions" do
    it "return all subscriptions of user" do
      5.times { UserSubscription.make!(:premium, user: user, creator: user) }
      get user_subscriptions_path(user), {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(5)
    end
  end

  describe "POST /users/:user_id/subscriptions" do
    context "with valid attributes and lifetime = true" do
      it "create a subscription and set user member to 3" do
        valid_attributes = { start_date: '2015-01-01', end_date: '2015-12-31', lifetime: true, reference: "XXX-XXX" }
        expect(user.member).to eq(0)
        expect {
          post user_subscriptions_path(user), valid_attributes , basic_header(user.auth_token)
        }.to change(UserSubscription, :count).by(1)
        expect(response.status).to eq 201
        user.reload
        expect(user.member).to eq(3)
      end
    end

    context "with valid attributes and lifetime = false and subscriptions day < 30" do
      it "create a subscription and set user member to 3" do
        valid_attributes = { start_date: '2015-01-01', end_date: '2015-01-15', lifetime: false, reference: "XXX-XXX" }
        expect(user.member).to eq(0)
        expect {
          post user_subscriptions_path(user), valid_attributes , basic_header(user.auth_token)
        }.to change(UserSubscription, :count).by(1)
        expect(response.status).to eq 201
        user.reload
        expect(user.member).to eq(2)
      end
    end

    context "with valid attributes and lifetime = false and subscriptions days > 30" do
      it "create a subscription and set user member to 3" do
        valid_attributes = { start_date: '2015-01-01', end_date: '2015-02-14', lifetime: false, reference: "XXX-XXX" }
        expect(user.member).to eq(0)
        expect {
          post user_subscriptions_path(user), valid_attributes , basic_header(user.auth_token)
        }.to change(UserSubscription, :count).by(1)
        expect(response.status).to eq 201
        user.reload
        expect(user.member).to eq(1)
      end
    end

    context "with invalid attributes" do
      pending
      # it "return the errors in format json" do
      #   expect {
      #     post user_subscriptions_path(user), invalid_attributes, basic_header(user.auth_token)
      #   }.to change(UserSubscription, :count).by(0)
      #   expect(json).to eq({"name"=>["can't be blank"]})
      #   expect(response.status).to eq 422
      # end
    end
  end

  describe "PUT /users/:user_id/subscriptions/:id" do
    pending
    # it "edit a subscription of user" do
      # user_subscription = UserSubscription.make!(:premium, user: user, creator: user)
      # put user_subscription_path(user, user_subscription), { end: "2015-01-01" }, basic_header(user.auth_token)
      # expect(response.status).to eq 200
      # user_subscription.reload
      # expect(user_subscription.end_date).to eq("2015-01-01")
    # end
  end

  describe "DELETE /users/:user_id/subscriptions/:id" do
    pending
    # it "delete a subscription of user" do
      # subscription = UserSubscription.make!(:premium, user: user, creator: user)
      # expect {
      #   delete user_subscription_path(user, subscription), {}, basic_header(user.auth_token)
      # }.to change(UserSubscription, :count).by(-1)
      # expect(response.status).to eq 204
    # end
  end
end