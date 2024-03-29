class V1::BasePostsController < V1::BaseController
  include Pundit
  before_action :set_postable
  before_action :set_post, except: [:index, :create]

  def index
    @q = @postable.posts.ransack(params[:q])
    @posts = @q.result
    #@posts = @q.page(params[:page]).per(params[:per_page])
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(params[:per_page])
    #if @posts.class == Array
    #  @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(params[:per_page])
    #else
    #  @posts = @posts.page(params[:page]).per(params[:per_page]) # if @posts is AR::Relation object
    #end
  end

  def show
  end

  def create
    service = ::Posts::CreatePost.new(@postable, current_user, post_params)
    if service.call
      @post = service.post
      # send notification email to tagged users, if any
      if @post.user_tags
        @post.user_tags.each do |user|
          UserMailer.user_tagged_in_post(user, @post).deliver_later
        end
      end
      render :show, status: :created
    else
      render json: service.post.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @post
    service = ::Posts::UpdatePost.new(@postable, @post, current_user, post_params)
    if service.call
      @post.comment_users.each do |comment_user|
        preference = comment_user.email_preferences.find_by(name: 'commented_post_edit')
        if not(preference.present?) || (preference.present? && preference.value == 0)
          UserMailer.user_edited_post_you_commented(comment_user, @post).deliver_later
        end
      end
      render :show, status: :ok,  location: [@postable, @post]
    else
      render json: service.post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.really_destroy!
    head :no_content
  end

  private

  def set_postable
  end

  def set_post
    if @postable
      @post = @postable.posts.find(params[:id])
    else
      render json: 'no parent given'
    end
  end

  def post_params
    params.permit(:body, :user_tags_list, :url, :url_title, :url_description,
      :url_image, :content_id, :content_type, :markup_body, picture_ids:[])
  end
end
