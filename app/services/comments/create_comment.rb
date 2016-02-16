module Comments
  class CreateComment

    attr_reader :commentable, :comment, :errors, :users

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
        send_notification_emails(@comment)
        true
      else
        @errors = @comment.errors
        false
      end
    end

    private

    def send_notification_emails(comment)
      users = []
      # check for users who liked the commentable (post, etc)
      comment.commentable.likes.each do |like|
        unless users.include?(like.user)
          #check is not current user
          if like.user != @current_user
            users << like.user
          end
        end
      end

      # check for users who commented the commentable (post, etc)
      comment.commentable.comments.each do |c|
        unless users.include?(c.user)
          #check is not current user or post creator
          if c.user != @current_user && comment.commentable.user != c.user
            users << c.user
          end
        end
      end

      # send email to selected users
      users.each do |user|
        preference = user.email_preferences.find_by(name: 'commented_or_liked_post_comment')
        if not(preference.present?) || (preference.present? && preference.value == 0)
          UserMailer.user_commented_post_you_commented_or_liked(user, comment).deliver_now
        end
      end
    end
  end
end