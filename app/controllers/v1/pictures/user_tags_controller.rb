class V1::Pictures::UserTagsController <  V1::BaseController
  before_action :set_picture

  def index
    @tags = @picture.user_taggings
  end

  def create
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