class V1::Me::ConversationsController < V1::BaseController
  before_action :set_user

  def show
    @conversation = @user.mailbox.conversations.find(params[:id])
    render 'v1/conversations/show', status: :ok
  end

  def create
    recipients = User.where(id: users_ids)
    @conversation = @user.send_message(recipients, body, subject).conversation
    render 'v1/conversations/show', status: :created
  end

  private
    def set_user
      @user = current_user if current_user
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
