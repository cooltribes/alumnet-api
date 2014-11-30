class V1::Me::ConversationsController < V1::BaseController
  before_action :set_user
  before_action :set_conversation, except: [:index, :create]

  ### Conversations

  def index
    @conversations = @user.mailbox.conversations
  end

  def show
  end

  def create
    recipients = User.where(id: users_ids)
    @conversation = @user.send_message(recipients, body, subject).conversation
    PusherDelegator.notify_new_message(@conversation.last_message, recipients.to_a)
    render :show, status: :created
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
      params.permit(:subject)[:subject] || "--"
    end
end
