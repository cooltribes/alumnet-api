class V1::CharacteristicsController < V1::BaseController
  before_action :set_characteristic, except: [:index, :create]

  def index
    @q = Characteristic.ransack(params[:q])
    @characteristics = @q.result
  end

  def show
  end

  def create
    @characteristic = Characteristic.new(characteristic_params)
    @characteristic.save
    render :show, status: :created,  location: @characteristic
  end

  def update
    if @characteristic.update(characteristic_params)
      render :show, status: :ok, location: @characteristic
    else
      render json: @characteristic.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @characteristic.destroy
    head :no_content
  end

  private

  def set_characteristic
    @characteristic = Characteristic.find(params[:id])
  end

  def characteristic_params
    params.permit(:name, :status, :mandatory, :measure_unit, :created_at, :updated_at)
  end

end