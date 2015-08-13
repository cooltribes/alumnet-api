class V1::Companies::CompanyAdminsController < V1::BaseController
  before_action :set_company
  before_action :set_contact_info, except: [:index, :create]

  def index
    @company_admins = @company.company_admins
  end

  def create
    @contact_info = ContactInfo.new(contact_info_params)
    if @company.company_admins << @contact_info
      render :show, status: :created
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def update
    if @contact_info.update(contact_info_params)
      render :show, status: :ok
    else
      render json: @contact_info.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_info.really_destroy!
    head :no_content
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_contact_info
    @contact_info = @company.company_admins.find(params[:id])
  end

  def contact_info_params
    params.permit(:contact_type, :info, :privacy)
  end

end
