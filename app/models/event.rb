class Event < ActiveRecord::Base
  include EventHelpers
  mount_uploader :cover, CoverUploader
  enum event_type: [:open, :closed, :secret]

  ### Relations
  belongs_to :creator, class_name: "User"
  belongs_to :country
  belongs_to :city
  belongs_to :eventable, polymorphic: true
  has_many :attendances, dependent: :destroy
  has_many :posts, as: :postable, dependent: :destroy
  has_many :albums, as: :albumable, dependent: :destroy


  ### Validations
  validates_presence_of :name, :description, :start_date, :end_date, :country_id

  ### Scopes
  scope :open, -> { where(event_type: 0) }
  scope :closed, -> { where(event_type: 1) }
  scope :secret, -> { where(event_type: 2) }

  scope :official, -> { where(official: true) }
  scope :non_official, -> { where(official: false) }

  ### Instance methods
  def create_attendance_for(user)
    attendances.create(user: user)
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

  def group_admins
    if eventable_type == 'Group'
      eventable.admins
    else
      []
    end
  end

  def is_admin?(user)
    return true if user == creator
    return true if group_admins.include?(user)
    false
  end
end
