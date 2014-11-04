class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  include LikeableMethods

  ### Relations
  has_many :likes, as: :likeable
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  ### Scopes
  default_scope -> { order('created_at ASC') }

  ### Validations
  validates_presence_of :comment, :user_id

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

end
