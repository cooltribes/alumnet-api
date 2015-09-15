class V1::Users::ProductsController < V1::BaseController
  before_action :set_user_product, except: [:index, :create]
  before_action :set_product
  before_action :set_user

  def index
    @user_products = @user.user_products
  end


  def create
    @user_product = UserProduct.new(create_params)
    if @user_product.save
      if @product.feature == "subscription"
        if @user.show_onboarding
          @user.update(show_onboarding: false)
        end
        UserMailer.subscription_purchase(@user_product).deliver_now
      end
      render :show, status: :created
    else
      render json: @user_product.errors, status: :unprocessable_entity
    end
  end

  # def update
  #   authorize @attendance
  #   if @attendance.update(update_params)
  #     render :show
  #   else
  #     render json: @attendance.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   authorize @attendance
  #   @attendance.destroy
  #   head :no_content
  # end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_product
      @user_product = UserProduct.find(params[:id])
    end

    def set_product
      if params[:product_id]
        @product = Product.find(params[:product_id])
      end
    end

    def create_params
      params.permit(:user_id, :product_id, :status, :start_date, :end_date, :quantity, :transaction_type, :created_at, :updated_at)
    end

    def update_params
      params.permit(:status, :start_date, :end_date, :quantity, :transaction_type)
    end

    def save_subscription
      subscription_params = { start_date: Time.zone.now, end_date: Time.zone.now + @user_product.remaining_quantity.months, user: @user, lifetime: false, ownership_type: 1, creator_id: @user.id }
      #@user_subscription = @user.build_subscription(subscription_params, current_user)
      @user_subscription = Subscription.create(subscription_params)
      #@user_subscription.save
    end

    def validate_avilable_points
      return false unless @user.profile.points >= @product.price
      return true
    end
end
