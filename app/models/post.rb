class Post < ActiveRecord::Base
  acts_as_paranoid
  acts_as_commentable
  include LikeableMethods
  include PostHelpers

  #Paginatin options
  paginates_per 2
  max_paginates_per 2

  ### Relations
  belongs_to :user ##Creator
  belongs_to :postable, polymorphic: true
  belongs_to :postable_group, foreign_key: :postable_id, class_name: 'Group'
  has_many :pictures, as: :pictureable, dependent: :destroy

  ### Scopes
  default_scope -> { order(last_comment_at: :desc) }

  ### Validations
  validates_presence_of :body, :user_id

  ### Callbacks
  before_create :set_last_comment_at
  after_create :assign_pictures_to_album

  ### Instance Methods

  def with_pictures(number)
    pictures.limit(number)
  end

  private
    def set_last_comment_at
      self[:last_comment_at] ||= Time.current
    end

    def assign_pictures_to_album
      if pictures.length > 0
        if postable_type == 'Group' || postable_type == 'Event'
          album = postable.albums.create_with(name: 'timeline').find_or_create_by(album_type: Album::TYPES[:timeline])
          pictures.each do |picture|
            album.pictures << picture
          end
        end
      end
    end
end
