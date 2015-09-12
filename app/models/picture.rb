class Picture < ActiveRecord::Base
  acts_as_commentable
  include Alumnet::Likeable
  include Alumnet::Taggable

  mount_uploader :picture, PictureUploader

  ### Relations
  belongs_to :album
  belongs_to :city, foreign_key: "city_id", class_name: 'City'
  belongs_to :country, foreign_key: "country_id", class_name: 'Country'
  belongs_to :pictureable, polymorphic: true
  belongs_to :uploader, class_name: 'User'

  ### Callbacks
  before_create :check_date_taken, :check_location

  ### Instances Methods
  def url_for_notification
    "#{pictureable.class.to_s.pluralize.downcase}/#{pictureable.id}/pictures/#{id}"
  end

  private

    def check_date_taken
      self.date_taken ||= self.album.date_taken if self.album.present?
    end

    def check_location
      if self.album.present?
        self.city_id ||= self.album.city_id
        self.country_id ||= self.album.country_id
      end
    end

end
