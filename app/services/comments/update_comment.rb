module Comments
  class UpdateComment

    attr_reader :commentable, :comment, :errors

    def initialize(commentable, comment, current_user, params)
      @commentable = commentable
      @comment = comment
      @current_user = current_user
      @params = params
    end

    def call
      user_tags_list = @params.delete(:user_tags_list)
      if @comment.update(@params)
        @comment.update_user_tags(user_tags_list, tagger: @current_user) if user_tags_list
        true
      else
        @errors = @comment.errors
        false
      end
    end
  end
end