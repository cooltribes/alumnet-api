class V1::Companies::CompanyAdminsController < V1::BaseController
  include Pundit
  before_action :set_company
  before_action :set_company_admin, except: [:index, :create]

  def index
    @q = @company.company_admins.sent.search(params[:q])
    @company_admins = @q.result
  end

  def create
    @company_admin = CompanyAdmin.new(company_admin_params)
    if @company.company_admins << @company_admin

      if @company.is_admin?(current_user) #If current user is admin, the request is already accepted
        @company_admin.mark_as_accepted_by(current_user)
      else  #If another user asked for admin, send an email to admins.
        Notification.notify_admin_request_to_company_admins(@company.accepted_admins.to_a, @current_user, @company)
      end  

      render :show, status: :created
    else
      render json: @company_admin.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize(@company)
    if @company_admin.mark_as_accepted_by(current_user)
      render :show, status: :ok
    else
      render json: @company_admin.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize(@company)
    @company_admin.destroy!
    head :no_content
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_company_admin
    @company_admin = @company.company_admins.find(params[:id])
  end

  def company_admin_params
    params.permit(:user_id)
  end

end
