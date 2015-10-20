module Posts
  class UpdatePost

    attr_reader :postable, :post, :errors

    def initialize(postable, post, current_user, params)
      @postable = postable
      @post = post
      @current_user = current_user
      @params = params
    end

    def call
      user_tags_list = @params.delete(:user_tags_list)
      if @post.update(@params)
        @post.update_user_tags(user_tags_list, tagger: @current_user) if user_tags_list
        true
      else
        @errors = @post.errors
        false
      end
    end
  end
end