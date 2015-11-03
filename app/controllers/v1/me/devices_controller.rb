class V1::Me::DevicesController < V1::BaseController
  before_action :set_user

  def index
    @q = @user.devices.search(params[:q])
    @devices = @q.result
  end

  def create
    @device = Device.new(device_params)
    if @user.devices << @device
      render :show, status: :created
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def device_params
    params.permit(:platform, :token)
  end

end
