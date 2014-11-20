class V1::Me::ConversationsController < V1::BaseController
  before_action :set_user
  before_action :set_conversation, except: [:index, :create]

  def index
    @conversations = @user.mailbox.conversations
    render 'v1/conversations/index', status: :ok
  end

  def show
    render 'v1/conversations/show', status: :ok
  end

  def create
    recipients = User.where(id: users_ids)
    @conversation = @user.send_message(recipients, body, subject).conversation
    render 'v1/conversations/show', status: :created
  end

  def reply
    @message = @user.reply_to_conversation(@conversation, body, subject).message
    render 'v1/conversations/reply', status: :created
  end

  def destroy
    @conversation.destroy
    # @conversation.move_to_trash(@user)
    head :no_content
  end

  private
    def set_user
      @user = current_user if current_user
    end

    def set_conversation
      @conversation = @user.mailbox.conversations.find(params[:id])
    end

    def users_ids
      params.permit(recipients:[])[:recipients]
    end

    def body
      params.permit(:body)[:body]
    end

    def subject
      params.permit(:subject)[:subject]
    end
end
