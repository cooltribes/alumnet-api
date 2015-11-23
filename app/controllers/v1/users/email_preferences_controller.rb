class V1::Users::EmailPreferencesController < V1::BaseController
  before_action :set_user

  def index
    @email_preferences = @user.email_preferences.order(:id)
  end


  def create
    @email_preference = EmailPreference.find_by(name: params[:name], user_id: params[:user_id])
    if @email_preference.present?
      @email_preference.value = params[:value]
    else
      @email_preference = EmailPreference.new(create_params)
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

    def create_params
      params.permit(:name, :user_id, :value)
    end

    def update_params
      params.permit(:value)
    end
end
