class Comment < ActiveRecord::Base
  acts_as_paranoid
  include ActsAsCommentable::Comment
  include LikeableMethods
  include CommentHelpers

  ### Relations
  belongs_to :commentable, polymorphic: true
  belongs_to :user ##Creator

  ### Scopes
  default_scope -> { order('created_at ASC') }

  ### Validations
  validates_presence_of :comment, :user_id

  ### Callback
  after_create :set_last_comment_at_on_post, :notify_to_users

  private
    def set_last_comment_at_on_post
      if commentable.respond_to?(:last_comment_at)
        commentable.update_column(:last_comment_at, created_at)
      end
    end

    def notify_to_users
      case commentable_type
        when "Post"
          unless user == commentable.user
            Notification.notify_comment_in_post_to_author(commentable.user, self, commentable)
          end
          if commentable.users_with_comments.any?
            Notification.notify_comment_in_post_to_users(commentable.users_with_comments.to_a, self, commentable)
          end
      end
    end
end
