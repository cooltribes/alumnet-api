class Comment < ActiveRecord::Base
  acts_as_paranoid
  include ActsAsCommentable::Comment
  include LikeableMethods
  include CommentHelpers

  ### Relations
  has_many :likes, as: :likeable, dependent: :destroy
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  ### Scopes
  default_scope -> { order('created_at ASC') }

  ### Validations
  validates_presence_of :comment, :user_id

  ### Callback
  after_create :set_last_comment_at_on_post

  private
    def set_last_comment_at_on_post
      if commentable.respond_to?(:last_comment_at)
        commentable.update_column(:last_comment_at, created_at)
      end
    end
end
