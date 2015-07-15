class V1::FeaturesController < V1::BaseController
  before_action :set_feature, except: [:index, :create, :validate]
  before_action :set_feature_for_validation, only: [:validate]

  def index
    @q = Feature.search(params[:q])
    @features = @q.result
  end

  def show
  end

  def create
    @feature = Feature.new(feature_params)
    @feature.save
    render :show, status: :created,  location: @feature
  end

  def update
    if @feature.update(feature_params)
      render :show, status: :ok, location: @feature
    else
      render json: @feature.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @feature.destroy
    head :no_content
  end

  def validate
    if @feature
      render json: { validation: @feature.status == 'active' }
    else
      render json: { validation: false }
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def set_feature_for_validation
    @feature = Feature.find_by(key_name: params[:key_name])
  end

  def feature_params
    params.permit(:name, :description, :status, :key_name, :created_at, :updated_at)
  end

end