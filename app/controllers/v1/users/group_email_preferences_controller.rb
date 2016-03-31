class V1::Users::GroupEmailPreferencesController < V1::BaseController
  before_action :set_user
  before_action :set_group, except: :index

  def index
    @email_preferences = @user.group_email_preferences
  end

  def create
    # TODO: Hacer review a esto :yondry
    @email_preference = GroupEmailPreference.find_by(user_id: params[:user_id], group_id: params[:group_id])
    if @email_preference.present?
      @email_preference.value = params[:value]
    else
      @email_preference = GroupEmailPreference.new(create_params)
    end

    if @email_preference.save
      render :show, status: :created
    else
      render json: @email_preference.errors, status: :unprocessable_entity
    end
  end

  # def update
  #   authorize @attendance
  #   if @attendance.update(update_params)
  #     render :show
  #   else
  #     render json: @attendance.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   authorize @attendance
  #   @attendance.destroy
  #   head :no_content
  # end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    def create_params
      params.permit(:user_id, :group_id, :value)
    end

    def update_params
      params.permit(:value)
    end
end
