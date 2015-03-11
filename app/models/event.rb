class Event < ActiveRecord::Base
  mount_uploader :cover, CoverUploader
  enum event_type: [:open, :closed, :secret]

  ### Relations
  belongs_to :creator, class_name: "User"
  belongs_to :country
  belongs_to :city
  belongs_to :eventable, polymorphic: true
  has_many :attendances, dependent: :destroy

  ### Validations
  validates_presence_of :name, :description

  ### Scopes
  scope :open, -> { where(group_type: 0) }
  scope :closed, -> { where(group_type: 1) }
  scope :secret, -> { where(group_type: 2) }

  scope :official, -> { where(official: true) }
  scope :non_official, -> { where(official: false) }

  # def creator
  #   user
  # end
end
