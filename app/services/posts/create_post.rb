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
      @post = Post.new(@params)
      @post.user = @current_user
      if postable.posts << @post
        @post.update_user_tags(user_tags_list) if user_tags_list
        true
      else
        @errors = @post.errors
        false
      end
    end
  end
end