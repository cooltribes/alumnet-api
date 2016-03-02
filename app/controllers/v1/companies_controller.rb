class V1::CompaniesController < V1::BaseController
  before_action :set_company, except: [:index, :create, :all, :managed, :search]

  def index
    q = Company.ransack(params[:q])
    @companies = q.result
    if @companies.class == Array
      @companies = Kaminari.paginate_array(@companies).page(params[:page]).per(params[:per_page])
    else
      @companies = @companies.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    end
  end

  def search
    @results = Company.search(params[:q]).page(params[:page]).per(params[:per_page])
    company_ids = @results.results.to_a.map(&:id)
    @companies = Company.where(id: company_ids)
    render :index, status: :ok
  end

  def all
    @companies = Company.all.order(:name)
    render :index
  end

  def managed
    @companies = @current_user.managed_companies.ransack(params[:q]).result
    render :index
  end

  def employees
    q = @company.current_employees.ransack(params[:q])
    @employees = q.result
  end

  def past_employees
    q = @company.past_employees.ransack(params[:q])
    @employees = q.result
    render :employees
  end

  def admins
    q = @company.accepted_admins.ransack(params[:q])
    @employees = q.result
    render :employees
  end

  def cropping
    image = params[:image]
    @company.assign_attributes(crop_params)
    @company.crop(image)
    render json: { status: 'success', url: @company.crop_url(image) }
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
    if @company.tasks.any?
      render json: { company: ["can't be delete because it has active job post"] },  status: :unprocessable_entity
    else
      @company.destroy
      head :no_content
    end
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.permit(:name, :logo, :profile_id, :description, :main_address,
        :size, :cover, :country_id, :city_id, :sector_id, :cover_position)
    end

    def crop_params
      params.permit(:imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH)
    end
end

