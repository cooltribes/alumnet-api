class V1::Albums::PicturesController < V1::BaseController
  include Pundit
  before_action :set_album
  before_action :set_picture, except: [:index, :create]

  def index
    @pictures = @album.pictures
  end

  def show
  end

  def create
    if params.key?(:file)
      @picture = Picture.new(create_picture_params)
      @picture.uploader = current_user
      if @album.pictures << @picture
        render :show, status: :created,  location: [@ilbum, @picture]
      else
        render json: @picture.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not file given" }, status: :unprocessable_entity
    end
  end

  def update
    authorize @picture
    if @picture.update(update_picture_params)
      render :show, status: :ok,  location: [@album, @picture]
    else
      render json: @picture.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @picture
    @picture.destroy
    head :no_content
  end

  private

  def set_album
    @album = Album.find(params[:album_id])
  end

  def set_picture
    if @album
      @picture = @album.pictures.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def picture_params
    params.permit(:title, :picture)
  end

  def update_picture_params
    params.permit(:title)
  end

  def create_picture_params
    # { title: params[:title], picture: params[:file]}
    {picture: params[:file]}
  end
end