class V1::Products::CharacteristicsController < V1::BaseController
  before_action :set_product_characteristic, except: [:index, :create]
  before_action :set_product
  before_action :set_characteristic

  def index
    @product_characteristics = @product.product_characteristics
  end

  # def show
  # end

  def create
    @product_characteristic = ProductCharacteristic.find_by(
      product_id: params[:product_id], 
      characteristic_id: params[:characteristic_id]
    )
    if @product_characteristic.present?
      @product_characteristic.value = params[:value]
    else
      @product_characteristic = ProductCharacteristic.new(product_characteristic_params)
    end
    @product_characteristic.save
    head :ok, content_type: "text/html"
    #render :show, status: :created, location: @product_characteristic
  end

  def destroy
    @product_characteristic.destroy
    head :no_content
  end

  private

  def set_product_characteristic
    @product_characteristic = ProductCharacteristic.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_characteristic
    if params[:characteristic_id]
      @characteristic = Characteristic.find(params[:characteristic_id])
    end
  end

  def product_characteristic_params
    params.permit(:id, :product_id, :characteristic_id, :value, :created_at, :updated_at)
  end

end