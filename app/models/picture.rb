class Picture < ActiveRecord::Base
  acts_as_commentable
  include Alumnet::Likeable
  include Alumnet::Taggable
  include Alumnet::Localizable

  mount_uploader :picture, PictureUploader

  ### Relations
  belongs_to :album
  belongs_to :pictureable, polymorphic: true
  belongs_to :uploader, class_name: 'User'

  ### Callbacks
  before_create :check_date_taken, :check_location

  ### Instances Methods
  def url_for_notification
    "#{pictureable.class.to_s.pluralize.downcase}/#{pictureable.id}/pictures/#{id}"
  end

  #TODO: maybe put this in own module for permissions
  def can_be_deleted_by(user)
    return true if uploader == user
    return true if user.is_admin?
    if album.present?
      return true if album.albumable_type == "Group" && album.albumable.user_is_admin?(user)
      return true if album.albumable_type == "Event" && album.albumable.is_admin?(user)
      return true if album.albumable_type == "User" && album.albumable == user
    end
  end

  private

    def check_date_taken
      self.date_taken ||= album.date_taken if album.present?
    end

    def check_location
      if album.present?
        self.city_id ||= album.city_id
        self.country_id ||= album.country_id
      end
    end

end
