class V1::Me::ReceiptsController < V1::BaseController
  before_action :set_user
  before_action :set_conversation

  ### Conversations

  def index
    @receipts = @conversation.receipts_for(@user).order(created_at: :asc)
  end

  def create
    @receipt = @user.reply_to_conversation(@conversation, body)
    render :show, status: :created
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
