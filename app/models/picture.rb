class Picture < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
  before_create :check_date_taken, :check_location

  belongs_to :album
  belongs_to :city, foreign_key: "city_id", class_name: 'City'
  belongs_to :country, foreign_key: "country_id", class_name: 'Country'
  belongs_to :pictureable, polymorphic: true
  belongs_to :uploader, class_name: 'User'

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
