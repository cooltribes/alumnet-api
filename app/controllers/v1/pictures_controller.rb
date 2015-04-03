class V1::PicturesController < V1::BaseController
  before_action :set_picture, except: [:index, :create]

  def index
    @pictures = Picture.all
  end

  def show
  end

  def create
    if params.key?(:file)
      @picture = Picture.new(create_picture_params)
      @picture.uploader = current_user
      if @picture.save
        render :show, status: :created,  location: @picture
      else
        render json: @picture.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not file given" }, status: :unprocessable_entity
    end
  end

  def update
    if @picture.update(picture_params)
      render :show, status: :ok,  location: @picture
    else
      render json: @picture.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @picture.destroy
    head :no_content
  end

  private

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.permit(:title)
  end

  def create_picture_params
    { title: params[:name], picture: params[:file]}
  end
end