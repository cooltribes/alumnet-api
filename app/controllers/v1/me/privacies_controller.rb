class V1::Me::PrivaciesController < V1::BaseController
  before_action :set_user
  before_action :set_privacy, except: [:index, :create]

  def index
    @q = @user.privacies.ransack(params[:q])
    @privacies = @q.result
    render :index
  end

  def create
    @privacy = Privacy.new(privacy_params)
    @privacy.user = @user
    if @user.privacies << @privacy
      render :show, status: :created
    else
      render json: @privacy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @privacy.update(privacy_params)
      render :show, status: :ok
    else
      render json: @privacy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @privacy.destroy
    head :no_content
  end

  private

  def set_user
    @user = current_user
  end

  def set_privacy
    @privacy = @user.privacies.find(params[:id])
  end

  def privacy_params
    params.permit(:privacy_action_id, :value)
  end

end
