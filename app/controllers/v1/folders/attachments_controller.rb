class V1::Folders::AttachmentsController < V1::BaseController
  include Pundit
  before_action :set_folder
  before_action :set_attachment, except: [:index, :create]
  before_action :check_new_folder, only: :update

  def index
    @q = @folder.attachments.search(params[:q])
    @attachments = @q.result
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.uploader = current_user
    @attachment.folder = @folder
    authorize @attachment
    if @attachment.save
      render :show, status: :created
    else
      render json: @attachment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @attachment
    @attachment.folder = @new_folder
    if @attachment.save
      render :show, status: :ok
    else
      render json: @attachment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @attachment
    @attachment.destroy
    head :no_content
  end

  private

  def set_folder
    @folder = Folder.find(params[:folder_id])
  end

  def set_attachment
    if @folder
      @attachment = @folder.attachments.find(params[:id])
    else
      render json: 'no folder given'
    end
  end

  def check_new_folder
    @new_folder = Folder.find_by(id: params[:new_folder_id])
    unless @new_folder
      render json: 'folder not found'
    end
  end

  def attachment_params
    params.permit(:name, :file, :folder_id)
  end
end
