class V1::Users::AlbumsController < V1::BaseController
  include Pundit

  before_action :set_user
  before_action :set_album, except: [:index, :create]

  def index
    @q = @user.albums.ransack(params[:q])
    @albums = @q.result
  end

  def show
  end

  def create
    @album = Album.new(album_params)
    @album.user = current_user #set the creator
    if @user.albums << @album
      render :show, status: :created,  location: [@user, @album]
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @album
    if @album.update(album_params)
      render :show, status: :ok,  location: [@user, @album]
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @album
    @album.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_album
    if @user
      @album = @user.albums.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def album_params
    params.permit(:name, :description, :date_taken, :city_id, :country_id)
  end

end
