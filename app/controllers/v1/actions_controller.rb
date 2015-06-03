class V1::ActionsController < V1::BaseController
  before_action :set_action, except: [:index, :create]

  def index
    @q = Action.search(params[:q])
    @actions = @q.result
  end

  def show
  end

  def create
    @action = Action.new(action_params)
    @action.save
    render :show, status: :created,  location: @action
  end

  def update
    if @action.update(action_params)
      render :show, status: :ok, location: @action
    else
      render json: @action.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @action.destroy
    head :no_content
  end

  private

  def set_action
    @action = Action.find(params[:id])
  end

  def action_params
    params.permit(:name, :description, :status, :value, :created_at, :updated_at)
  end

end