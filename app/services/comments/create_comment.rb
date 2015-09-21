module Comments
  class CreateComment

    attr_reader :commentable, :comment, :errors

    def initialize(commentable, current_user, params)
      @commentable = commentable
      @current_user = current_user
      @params = params
    end

    def call
      user_tags_list = @params.delete(:user_tags_list)
      @comment = Comment.new(@params)
      @comment.user = @current_user
      if commentable.comments << @comment
        @comment.update_user_tags(user_tags_list, tagger: @current_user) if user_tags_list
        true
      else
        @errors = @comment.errors
        false
      end
    end
  end
end