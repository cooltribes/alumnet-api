class V1::PrizesController < V1::BaseController
  before_action :set_prize, except: [:index, :create]

  def index
    @q = Prize.search(params[:q])
    @prizes = @q.result
  end

  def show
  end

  def create
    @prize = Prize.new(prize_params)
    @prize.save
    render :show, status: :created,  location: @prize
  end

  def update
    if @prize.update(prize_params)
      render :show, status: :ok, location: @prize
    else
      render json: @prize.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @prize.destroy
    head :no_content
  end

  private

  def set_prize
    @prize = Prize.find(params[:id])
  end

  def prize_params
    params.permit(:name, :description, :status, :price, :created_at, :updated_at, :prize_type)
  end

end