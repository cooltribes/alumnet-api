class V1::SenioritiesController < V1::BaseController
  include Pundit
  before_action :set_seniority, except: [:index, :create]

  def index
    @q = Seniority.ransack(params[:q])
    @seniorities = @q.result
  end

  def create
    @seniority = Seniority.new(seniority_params)
    authorize @seniority
    if @seniority.save
      render :show, status: :created,  location: @seniority
    else
      render json: @seniority.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @seniority
    if @seniority.update(seniority_params)
      render :show, status: :ok,  location: @seniority
    else
      render json: @seniority.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @seniority
    @seniority.destroy
    head :no_content
  end

  private

  def set_seniority
    @seniority = Seniority.find(params[:id])
  end

  def seniority_params
    params.permit(:name, :seniority_type)
  end

end
