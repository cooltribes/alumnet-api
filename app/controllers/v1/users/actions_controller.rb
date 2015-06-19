class V1::Users::ActionsController < V1::BaseController
  before_action :set_user
  before_action :set_user_action, only: [:update, :destroy]

  def index
    @user_actions = @user.user_actions
    @user_actions.each do |a|
      if a.generator_type == "accepted_invitation"
        invitation = Invitation.find(a.generator_id)
        a.invited_user = invitation.guest
      end
    end
  end

  def history
    @user_actions = @user.user_actions
    @user_prizes = @user.user_prizes
    @history = (@user_actions + @user_prizes).sort_by(&:created_at).reverse
    @history.each do |a|
      if a.class.name == 'UserAction'
        if a.generator_type == "accepted_invitation"
          invitation = Invitation.find(a.generator_id)
          a.invited_user = invitation.guest
        end
      end
    end
  end

  def create
    @user_action = @user.build_action(action_params, current_user)
    if @user_action.save
      render :show, status: :created
    else
      render json: @user_action.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user_action.update(subscription_params)
      render :show
    else
      render json: @user_action.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user_action.destroy
    head :no_content
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_action
      @user_action = @user.user_actions.find(params[:id])
    end

    def subscription_params
      params.permit(:start_date, :end_date, :user_id, :lifetime)
    end
end