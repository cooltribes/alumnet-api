class V1::BaseFoldersController < V1::BaseController
  include Pundit
  before_action :set_folderable
  before_action :set_folder, except: [:index, :create]

  def index
    @q = @folderable.folders.search(params[:q])
    @folders = @q.result
  end

  def show
  end

  def create
    @folder = Folder.new(folder_params)
    @folder.creator = current_user
    authorize @folder
    if @folderable.folders << @folder
      render :show, status: :created
    else
      render json: @folder.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @folder
    if @folder.update(folder_params)
      render :show, status: :ok
    else
      render json: @folder.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @folder
    @folder.destroy
    head :no_content
  end

  private

  def set_folderable
  end

  def set_folder
    if @folderable
      @folder = @folderable.folders.find(params[:id])
    else
      render json: 'no parent given'
    end
  end

  def folder_params
    params.permit(:name)
  end
end
