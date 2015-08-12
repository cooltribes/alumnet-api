class V1::CompaniesController < V1::BaseController
  before_action :set_company, except: [:index, :create]

  def index
    @q = Company.search(params[:q])
    @companies = @q.result
  end

  def employees
    @q = @company.employees.search(params[:q])
    @employees = @q.result
  end

  def past_employees
    @q = @company.past_employees.search(params[:q])
    @employees = @q.result
    render :employees
  end

  def create
    @company = Company.new(company_params)
    @company.creator = current_user
    if @company.save
      render :show, status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render :show, status: :ok
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    head :no_content
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.permit(:name, :logo, :profile_id, :description, :main_address,
        :size, :cover, :country_id, :city_id, :sector_id,)
    end

end

