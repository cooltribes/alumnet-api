class V1::Users::BusinessController < V1::BaseController
  include Pundit

  before_action :set_user
  before_action :set_business, except: [:index, :create]

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
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_business
    if @user
      @business = @user.company_relations.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end
  
  def business_params
    params.permit(:company_name, :company_logo, :offer, :search, :business_me,
      keywords_offer: [], keywords_search: [])
  end

end
