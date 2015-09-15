class V1::Pictures::UserTagsController <  V1::BaseController
  before_action :set_picture

  def index
    @tags = @picture.user_taggings
  end

  def create
    attrs = { user_id: params[:user_id], tagger: @current_user, position: params[:position] }
    if @picture.user_taggings.exists?(user_id: params[:user_id], tagger:  @current_user)
      render json: { errors: ["the user is tagged"] }, status: :unprocessable_entity
    else
      @tag = @picture.user_taggings.create(attrs)
      render :show
    end
  end

  def destroy
    @tag = @picture.user_taggings.find(params[:id])
    @tag.destroy
  end

  private

    def set_picture
      @picture = Picture.find(params[:picture_id])
    end

end