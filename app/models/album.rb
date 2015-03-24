class Album < ActiveRecord::Base

  belongs_to :user
  belongs_to :albumable, polymorphic: true
  belongs_to :city, foreign_key: "city_id", class_name: 'City'
  belongs_to :country, foreign_key: "country_id", class_name: 'Country'

  has_many :pictures, dependent: :destroy

  def creator
    user
  end

  def cover_picture
    pictures.first.try(:picture)
  end


  def pictures_count
    self.pictures.count
  end

end
