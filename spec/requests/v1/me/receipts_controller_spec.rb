require 'rails_helper'

describe V1::Me::ReceiptsController, type: :request do
  let!(:current_user) { User.make! }
  let!(:friend_one) { User.make! }
  let!(:friend_two) { User.make! }

  def create_conversation
    conversation = current_user.send_message([friend_two, friend_one], "Hi guys!", "Say Hi").conversation
    friend_one.reply_to_conversation(conversation, "Hi current user", "Reply")
    friend_two.reply_to_conversation(conversation, "Fu.. you", "Reply")
    conversation
  end

  describe "GET /me/conversations/:id/receipts" do
    before do
      current_user.send_message([friend_one], "Hi guy!", "Say Hi to friend on")
      current_user.send_message([friend_two], "Bye!", "Say adieu to friend two")
    end
    it "should return all conversations of current user" do
      conversation = create_conversation
      get me_conversation_receipts_path(conversation), {}, basic_header(current_user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(3)
    end
  end

  describe "POST /me/conversations/:id/receipts" do
    it "should create a reply in conversation" do
      conversation = create_conversation
      expect {
        post me_conversation_receipts_path(conversation), { body: "Hi again" }, basic_header(current_user.api_token)
      }.to change(conversation.messages, :count).by(1)
      expect(response.status).to eq 201
      expect(json['body']).to eq("Hi again")
    end
  end

end