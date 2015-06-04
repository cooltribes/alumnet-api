class V1::Users::BusinessController < V1::BaseController
  include Pundit

  before_action :set_user
  before_action :set_business_info, except: [:index, :create]

  def index
    @q = @user.profile.company_relations.search(params[:q])
    @companies = @q.result
    # render :index
  end

  def show
  end

  def create

    # @company = Company.find_or_create_by(company_params.name)

    @company = Company.new(company_params)
    @company.profile = @user.profile
    @company.save()
    @company_relation = CompanyRelation.new(business_params)
    @company_relation.company = @company


    if @user.profile.company_relations << @company_relation
      render :show, status: :created
    else
      render json: @Company.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    if @post.update(post_params)
      render 'v1/users/posts/show', status: :ok,  location: [@user, @post]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_business_info
    if @user
      @post = @user.posts.find(params[:id])
    else
      render json: 'TODO get this error'
    end
  end

  def post_params
    params.permit(:body, picture_ids:[])
  end

  def company_params
    params.permit(:company)
  end
  def business_params
    params.permit(:offer, :search, :business_me)
  end

end
