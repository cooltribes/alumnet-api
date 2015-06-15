class Event < ActiveRecord::Base
  include EventHelpers
  mount_uploader :cover, CoverUploader
  enum event_type: [:open, :closed, :secret]

  ## Virtual Attributes
  attr_accessor :cover_uploader
  attr_accessor :imgInitH, :imgInitW, :imgW, :imgH, :imgX1, :imgY1, :cropW, :cropH
  attr_accessor :invite_group_members

  ### Relations
  has_many :attendances, dependent: :destroy
  has_many :posts, as: :postable, dependent: :destroy
  has_many :albums, as: :albumable, dependent: :destroy
  belongs_to :creator, class_name: "User"
  belongs_to :country
  belongs_to :city
  belongs_to :eventable, polymorphic: true

  ### Callbacks
  after_save :save_cover_in_album
  after_create :send_invites

  ### Validations
  validates_presence_of :name, :description, :start_date, :end_date, :country_id

  ### Scopes
  scope :open, -> { where(event_type: 0) }
  scope :closed, -> { where(event_type: 1) }
  scope :secret, -> { where(event_type: 2) }

  scope :official, -> { where(official: true) }
  scope :non_official, -> { where(official: false) }

  ### Instance methods

  ### Croping Cover
  def crop
    cover.recreate_versions! if imgX1.present?
  end

  def create_attendance_for(user)
    attendances.find_or_create_by(user: user)
  end

  def attendance_for(user)
    attendances.find_by(user_id: user.id)
  end

  def contacts_for(user, query)
    if eventable_type == 'Group'
      group_members = eventable.members.search(query).result
      user_friends = user.search_accepted_friends(query)
      users = group_members | user_friends
    elsif eventable_type == 'User'
      users = user.search_accepted_friends(query)
    end
    users
  end

  def can_attend?(user)
    return true if open?
    return true if is_admin?(user)
    return true if closed? && attendance_for(user)
  end

  def group_admins
    return eventable_type == 'Group' ? eventable.admins : []
  end

  def group_members
    return eventable_type == 'Group' ? eventable.members : []
  end

  def is_admin?(user)
    return true if user == creator
    return true if group_admins.include?(user)
    false
  end

  private

    def save_cover_in_album
      if cover_changed?
        album = albums.create_with(name: 'covers').find_or_create_by(album_type: Album::TYPES[:cover])
        picture = Picture.new(uploader: cover_uploader)
        picture.picture = cover
        album.pictures << picture
      end
    end

    def send_invites
      if invite_group_members == "true"
        group_members.each do |member|
          create_attendance_for(member)
        end
      end
    end
end
