class V1::CompaniesController < V1::BaseController
  before_action :set_company, except: [:index, :create]

  def index
    @q = Company.search(params[:q])
    @companies = @q.result
  end

  def create
    @company = Company.new(company_params)
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
      params.permit(:name, :logo)
    end

end