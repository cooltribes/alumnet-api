class Post < ActiveRecord::Base
  acts_as_paranoid
  acts_as_commentable
  include Alumnet::Likeable
  include Alumnet::Taggable
  include PostHelpers

  #Paginatin options
  paginates_per 2
  max_paginates_per 2

  ### types
  # TYPES = ["regular", "share"]

  ### Relations
  belongs_to :user ##Creator
  belongs_to :postable, polymorphic: true
  belongs_to :postable_group, foreign_key: :postable_id, class_name: "Group"
  has_many :pictures, as: :pictureable, dependent: :destroy
  has_many :comment_users, through: :comments, source: :user #users with comments
  ###THIS IS EXPERIMENTAL
    ##Un post pertenece o tiene un Content polimorfico. [post-link-video]
  belongs_to :content, polymorphic: true
    ##Al mismo tiempo un posts puede tener muchos posts como Content.
    ##Es decir, los posts donde el post es contenido, osea un post que se compartio. :s
  has_many :posts, as: :content, dependent: :destroy
  #########################

  ### Scopes
  default_scope -> { order(last_comment_at: :desc) }

  ### Validations
  validates_presence_of :user_id

  ### Callbacks
  before_create :set_last_comment_at, :set_type
  after_create :assign_pictures_to_album, :notify_to_users

  ### Instance Methods
  def url_for_notification
    "#{postable.class.to_s.pluralize.downcase}/#{postable.id}/posts/#{id}"
  end

  def with_pictures(number)
    pictures.limit(number)
  end

  def users_with_comments(user_ids = [])
    #all users with comments except the users_id given and post creator
    user_ids << user.id
    comment_users.where.not(comments: { user_id: user_ids }).distinct
  end

  def in_group_or_event?
    postable_type == "Group" || postable_type == "Event"
  end

  def in_own_timeline?
    postable_type == "User" && user_id == postable_id
  end

  def in_group_closed_or_secret?
    postable_type == "Group" && (postable.closed? || postable.secret?)
  end

  def in_event_closed_or_secret?
    postable_type == "Event" && (postable.closed? || postable.secret?)
  end

  private

    def set_type
      if content && content_type == "Post"
        self[:post_type] = "share"
      else
        self[:post_type] = "regular"
      end
    end

    def set_last_comment_at
      self[:last_comment_at] ||= Time.current
    end

    def assign_pictures_to_album
      if pictures.length > 0 && in_group_or_event? || in_own_timeline?
        album = postable.albums.create_with(name: "timeline").find_or_create_by(album_type: Album::TYPES[:timeline])
        pictures.each do |picture|
          album.pictures << picture
        end
      end
    end

    def notify_to_users
      users = case postable_type
        when "Group"
          postable.members(excluded_users: [user_id]).to_a
        when "Event"
          postable.assistants(excluded_users: [user_id]).to_a
        else
          []
      end
      Notification.notify_new_post(users, self)
    end
end
