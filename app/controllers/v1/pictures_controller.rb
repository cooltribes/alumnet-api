class V1::PicturesController < V1::BaseController
  before_action :set_picture, except: [:index, :create]

  def index
    @pictures = Picture.all
  end

  def show
  end

  def create
    if params[:file]
      picture = params[:file]
      title = params[:name]
      @picture = Picture.new(title: title, picture: picture)
      if @picture.save
        render :show, status: :created,  location: @picture
      else
        render json: @picture.errors, status: :unprocessable_entity
      end
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

end