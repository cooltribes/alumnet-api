class V1::Companies::BranchesController < V1::BaseController
  before_action :set_company
  before_action :set_branch, except: [:index, :create]

  def index
    @q = @company.branches.ransack(params[:q])
    @branches = @q.result
  end

  def create
    @branch = Branch.new(branch_params)
    if @company.branches << @branch
      render :show, status: :created,  location: [@company, @branch]
    else
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  def update
    if @branch.update(branch_params)
      render :show, status: :ok,  location: [@company, @branch]
    else
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @branch.destroy
    head :no_content
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_branch
    if @company
      @branch = @company.branches.find(params[:id])
    else
      render json: 'Company not given'
    end
  end

  def branch_params
    params.permit(:address, :country_id, :city_id)
  end

end
