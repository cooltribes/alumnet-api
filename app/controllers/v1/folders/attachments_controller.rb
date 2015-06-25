class V1::Folders::AttachmentsController < V1::BaseController
  include Pundit
  before_action :set_folder
  before_action :set_attachment, except: [:index, :create]

  def index
    @q = @folder.attachments.search(params[:q])
    @attachments = @q.result
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.uploader = current_user
    if @folder.attachments << @attachment
      render :show, status: :created
    else
      render json: @attachment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @attachment
    if @attachment.update(attachment_params)
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

  def attachment_params
    params.permit(:name, :file, :folder_id)
  end
end
