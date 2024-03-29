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
        send_notification_emails(commentable, @comment, @current_user)
        true
      else
        @errors = @comment.errors
        false
      end
    end

    private

    def send_notification_emails(commentable, created_comment, current_user)
      users = []
      commentable.likes.each do |like|
        users << like.user unless like.is_owner?(current_user)
      end

      commentable.comments.each do |comment|
        users << comment.user if !comment.is_owner?(current_user) && !commentable.is_owner?(comment.user)
      end

      mailer = GeneralMailer.new

      # send email to selected users (likes and comments)
      users.uniq.each do |user|
        preference = user.email_preferences.find_by(name: 'commented_or_liked_post_comment')
        if not(preference.present?) || (preference.present? && preference.value == 0)
          #UserMailer.user_commented_post_you_commented_or_liked(user, created_comment).deliver_later
          mailer.user_commented_post_you_commented_or_liked(user, created_comment)
        end
      end

      # send email to post author
      #UserMailer.user_commented_post(created_comment).deliver_now
      if !commentable.is_owner?(comment.user)
        if commentable.class.to_s == 'Picture'
          mailer.user_commented_post(commentable.pictureable.user, created_comment) if commentable.pictureable.present?
        else
          mailer.user_commented_post(commentable.user, created_comment)
        end
      end

      # send email to users tagged on post
      commentable.user_tags.uniq.each do |user|
        unless users.include?(user)
          UserMailer.user_commented_post_you_are_tagged_in(user, created_comment).deliver_later
        end
      end
    end
  end
end