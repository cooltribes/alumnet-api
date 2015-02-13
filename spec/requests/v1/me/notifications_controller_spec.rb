require 'rails_helper'

describe V1::Me::NotificationsController, type: :request do
  let!(:current_user) { User.make! }

  before do
    2.times do |x|
      Mailboxer::Notification.notify_all([current_user], "Subject of Notification",
      "The Body of notification")
    end
  end

  describe "GET /me/notifications" do
    it "should return all notifications of current user" do
      get me_notifications_path, {}, basic_header(current_user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "DELETE /me/notifications/:id" do
    it "sent the conversation to trash" do
      notification = current_user.mailbox.notifications.first
      expect {
        delete me_notification_path(notification), {}, basic_header(current_user.auth_token)
      }.to change(current_user.mailbox.notifications, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end