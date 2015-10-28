module Posts
  class CreatePost

    attr_reader :postable, :post, :errors

    def initialize(postable, current_user, params)
      @postable = postable
      @current_user = current_user
      @params = params
    end

    def call
      user_tags_list = @params.delete(:user_tags_list)
      content = set_content
      @post = Post.new(@params)
      @post.user = @current_user
      @post.content = content if content
      if postable.posts << @post
        @post.update_user_tags(user_tags_list, tagger: @current_user) if user_tags_list
        true
      else
        @errors = @post.errors
        false
      end
    end

    private
      def set_content
        content_id = @params.delete(:content_id)
        content_type = @params.delete(:content_type)
        if content_id && content_type
          if content_type == "Post"
            Post.find content_id
          end
        end
      end
  end
end