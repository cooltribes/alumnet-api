class V1::Albums::PicturesController < V1::BaseController
  # include Pundit
  before_action :set_album
  before_action :set_picture, except: [:index, :create]

  def index
    @pictures = @album.pictures
  end

  def show
  end

  def create
    @picture = Picture.new(picture_params)
    # @picture.user = current_user
    if @album.pictures << @picture
      render :show, status: :created,  location: [@album, @picture]
    else
      render json: @picture.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      render :show, status: :ok,  location: [@album, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    head :no_content
  end

  def like
    like = @comment.add_like_by(current_user)
    if like.valid?
      render json: like, status: :ok
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unlike
    response = @comment.remove_like_of(current_user)
    render json: { ok: response}, status: :ok
  end

  private

  def set_album
    @album = Album.find(params[:album_id])
  end

  def set_picture
    if @album
      @comment = @album.comments.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def picture_params
    params.permit(:title, :picture)
  end
end