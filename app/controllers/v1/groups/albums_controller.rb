class V1::Groups::AlbumsController < V1::BaseController
  include Pundit

  before_action :set_group
  before_action :set_album, except: [:index, :create]
  
  def index
    @q = @group.albums.search(params[:q])
    @albums = @q.result
  end  

  def show
  end
  
  def create
    @album = Album.new(album_params)
    @album.user = current_user #set the creator
    if @group.albums << @album
      render :show, status: :created,  location: [@group, @album]
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

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_album
    if @group
      @album = @group.albums.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def album_params
    params.permit(:name, :description, :date_taken, :city_id, :country_id)
  end

end
