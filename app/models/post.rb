class Post < ActiveRecord::Base
  acts_as_paranoid
  acts_as_commentable
  include LikeableMethods
  include PostHelpers

  ### Relations
  belongs_to :user ##Creator
  belongs_to :postable, polymorphic: true
  belongs_to :postable_group, foreign_key: :postable_id, class_name: 'Group'
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :pictures, as: :pictureable, dependent: :destroy

  ### Scopes
  default_scope -> { order(last_comment_at: :desc) }

  ### Validations
  validates_presence_of :body, :user_id

  ### Callbacks
  before_create :set_last_comment_at

  ### Instance Methods

  private
    def set_last_comment_at
      self[:last_comment_at] ||= Time.current
    end
end
