class V1::Me::ReceiptsController < V1::BaseController
  before_action :set_user
  before_action :set_conversation

  ### Conversations

  def index
    @receipts = @conversation.receipts_for(@user).order(created_at: :asc)
  end

  def create
    @receipt = @user.reply_to_conversation(@conversation, body)
    recipients = @conversation.recipients
    recipients.delete(@user)
    PusherDelegator.send_message(@receipt.message, recipients)
    render :show, status: :created
  end

  def read
    @receipt = @user.receipts.find(params[:id])
    @receipt.mark_as_read
    render :show
  end

  def unread
    @receipt = @user.receipts.find(params[:id])
    @receipt.mark_as_unread
    render :show
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_conversation
      @conversation = @user.mailbox.conversations.find(params[:conversation_id])
    end

    def body
      params.permit(:body)[:body]
    end
end
