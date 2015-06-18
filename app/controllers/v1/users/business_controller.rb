class V1::Users::BusinessController < V1::BaseController
  include Pundit

  before_action :set_user
  before_action :set_business, only: [:update]

  def index
    @q = @user.profile.company_relations.search(params[:q])
    @companies = @q.result
    # render :index
  end

  def create
    @businessRelation = BusinessRelation.new(business_params, current_user)
    if @business = @businessRelation.save
      render :show, status: :created
    else
      render json: @businessRelation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @business.update(update_business_params)
      render :show
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_business
    @business = CompanyRelation.find(params[:id])
  end

  def business_params
    params.permit(:company_name, :company_logo, :offer, :search, :business_me,
      offer_keywords: [], search_keywords: [])
  end

  def update_business_params
    params.permit(:offer, :search, :business_me, offer_keywords: [], search_keywords: [])
  end

end
