require 'rails_helper'

describe V1::Me::ConversationsController, type: :request do
  let!(:current_user) { User.make! }
  let!(:friend_one) { User.make! }
  let!(:friend_two) { User.make! }

  def conversation_attributes
    { recipients: [friend_two.id, friend_one.id], subject: "New Conversation",
      body: "This is a new message in our conversation" }
  end

  def create_conversation
    conversation = current_user.send_message([friend_two, friend_one], "Hi guys!", "Say Hi").conversation
    friend_one.reply_to_conversation(conversation, "Hi current user", "Reply")
    friend_two.reply_to_conversation(conversation, "Fu.. you", "Reply")
    conversation
  end

  describe "GET /me/conversations" do
    before do
      current_user.send_message([friend_one], "Hi guy!", "Say Hi to friend on")
      current_user.send_message([friend_two], "Bye!", "Say adieu to friend two")
    end
    it "should return all conversations of current user" do
      get me_conversations_path, {}, basic_header(current_user.api_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "GET /me/conversations/:id" do
    it "should return the conversation by id and last message" do
      conversation = create_conversation
      get me_conversation_path(conversation), {}, basic_header(current_user.api_token)
      expect(response.status).to eq 200
      expect(json["subject"]).to eq("Say Hi")
      expect(json["is_read"]).to eq(false)
    end
  end

  describe "POST /me/conversations" do
    it "should create a conversations and first message" do
      post me_conversations_path, conversation_attributes, basic_header(current_user.api_token)
      expect(current_user.mailbox.conversations.count).to eq(1)
      expect(friend_two.mailbox.conversations.count).to eq(1)
      expect(friend_one.mailbox.conversations.count).to eq(1)
      expect(response.status).to eq 201
      expect(json["subject"]).to eq("New Conversation")
      expect(json["is_read"]).to eq(true)
    end
  end

  describe "DELETE /me/conversations/:id" do
    it "sent the conversation to trash" do
      conversation = create_conversation
      expect {
        delete me_conversation_path(conversation), {}, basic_header(current_user.api_token)
      }.to change(current_user.mailbox.conversations, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end