class V1::Branches::ContactInfosController < V1::BaseController
  before_action :set_branch
  before_action :set_contact_info, except: [:index, :create]

  def index
    @contact_infos = @branch.contact_infos
    render 'v1/companies/contact_infos/index'
  end

  def create
    @contact_info = ContactInfo.new(contact_info_params)
    if @branch.contact_infos << @contact_info
      render 'v1/companies/contact_infos/show', status: :created
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def update
    if @contact_info.update(contact_info_params)
      render 'v1/companies/contact_infos/show', status: :ok
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_info.really_destroy!
    head :no_content
  end

  private

  def set_branch
    @branch = Branch.find(params[:branch_id])
  end

  def set_contact_info
    @contact_info = @branch.contact_infos.find(params[:id])
  end

  def contact_info_params
    params.permit(:contact_type, :info, :privacy)
  end

end
