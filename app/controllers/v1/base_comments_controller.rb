class V1::BaseCommentsController < V1::BaseController
  include Pundit
  before_action :set_commentable
  before_action :set_comment, except: [:index, :create]
  after_action :send_notification_emails, only: [:create]

  def index
    @comments = @commentable.comments
  end

  def show
  end

  def create
    service = ::Comments::CreateComment.new(@commentable, current_user, comment_params)
    if service.call
      @comment = service.comment
      render :show, status: :created
    else
      render json: service.comment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @comment
    service = ::Comments::UpdateComment.new(@commentable, @comment, current_user, comment_params)
    if service.call
      render :show, status: :ok,  location: [@commentable, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @comment
    @comment.really_destroy!
    head :no_content
  end

  def like
    like = @comment.add_like_by(current_user)
    if like.valid?
      render json: like, status: :ok
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unlike
    response = @comment.remove_like_of(current_user)
    render json: { ok: response}, status: :ok
  end

  private

  def set_commentable
  end

  def set_comment
    if @commentable
      @comment = @commentable.comments.find(params[:id])
    else
      render json: 'no parent given'
    end
  end

  def comment_params
    params.permit(:comment, :markup_comment, :user_tags_list)
  end

  def send_notification_emails
    users = []
    # check for users who liked the commentable (post, etc)
    @comment.commentable.likes.each do |like|
      unless users.include?(like.user)
        #check is not creator user
        if like.user.id != @comment.commentable.user.id && like.user.id != current_user.id
          users << like.user
        end
      end
    end

    # check for users who commented the commentable (post, etc)
    @comment.commentable.comments.each do |comment|
      unless users.include?(comment.user)
        #check is not creator user
        if comment.user.id != @comment.commentable.user.id && comment.user.id != current_user.id
          users << comment.user
        end
      end
    end

    # send email to selected users
    users.each do |user|
      preference = user.email_preferences.find_by(name: 'commented_or_liked_post_comment')
      if not(preference.present?) || (preference.present? && preference.value == 0)
        UserMailer.user_commented_post_you_commented_or_liked(user, @comment).deliver_now
      end
    end
  end
end