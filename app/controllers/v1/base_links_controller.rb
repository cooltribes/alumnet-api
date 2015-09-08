class V1::BaseLinksController < V1::BaseController
  before_action :set_linkable
  before_action :set_link, except: [:index, :create]

  def index
    @q = @linkable.links.search(params[:q])
    @links = @q.result
  end

  def create
    @link = Link.new(link_params)
    if @linkable.links << @link
      render :show, status: :created
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  def update
    if @link.update(link_params)
      render :show, status: :ok
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    head :no_content
  end

  private

  def set_linkable
    # set linkable
  end

  def set_link
    if @linkable
      @link = @linkable.links.find(params[:id])
    else
      render json: 'no linkable given'
    end
  end

  def link_params
    params.permit(:title, :description, :url)
  end
end
