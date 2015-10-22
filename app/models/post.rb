class Post < ActiveRecord::Base
  acts_as_paranoid
  acts_as_commentable
  include Alumnet::Likeable
  include Alumnet::Taggable
  include PostHelpers


  #Paginatin options
  paginates_per 2
  max_paginates_per 2

  ### Relations
  belongs_to :user ##Creator
  belongs_to :postable, polymorphic: true
  belongs_to :postable_group, foreign_key: :postable_id, class_name: 'Group'
  has_many :pictures, as: :pictureable, dependent: :destroy
  has_many :comment_users, through: :comments, source: :user #users with comments

  ### Scopes
  default_scope -> { order(last_comment_at: :desc) }

  ### Validations
  validates_presence_of :body, :user_id

  ### Callbacks
  before_create :set_last_comment_at
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

  private

    def in_group_or_event?
      postable_type == 'Group' || postable_type == 'Event'
    end

    def in_own_timeline?
      postable_type == "User" && user_id == postable_id
    end

    def set_last_comment_at
      self[:last_comment_at] ||= Time.current
    end

    def assign_pictures_to_album     
      if pictures.length > 0 && in_group_or_event? || in_own_timeline?
        album = postable.albums.create_with(name: 'timeline').find_or_create_by(album_type: Album::TYPES[:timeline])
        pictures.each do |picture|
          album.pictures << picture
        end
      end      
    end

    def notify_to_users
      case postable_type
        when "Group"
          Notification.notify_new_post(postable.members.to_a, self) if postable.members.any?
        when "Event"
          Notification.notify_new_post(postable.assistants.to_a, self) if postable.assistants.any?
      end
    end
end
