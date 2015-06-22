class V1::KeywordsController < V1::BaseController
  before_action :set_keyword, except: [:index, :create]

  def index
    @q = Keyword.search(params[:q])
    @keywords = @q.result
  end

  def create
    @keyword = Keyword.new(keyword_params)
    if @keyword.save
      render :show, status: :created
    else
      render json: @keyword.errors, status: :unprocessable_entity
    end
  end

  def update
    if @keyword.update(keyword_params)
      render :show, status: :ok
    else
      render json: @keyword.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @keyword.destroy
    head :no_content
  end

  private
    def set_keyword
      @keyword = Keyword.find(params[:id])
    end

    def keyword_params
      params.permit(:name)
    end

end