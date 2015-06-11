class V1::Users::BusinessController < V1::BaseController
  include Pundit

  before_action :set_user

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

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def business_params
    params.permit(:company_name, :company_logo, :offer, :search, :business_me,
      keywords_offer: [], keywords_search: [])
  end

end
