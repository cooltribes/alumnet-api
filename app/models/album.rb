class Album < ActiveRecord::Base
  include Alumnet::Localizable

  TYPES = { regular: 0, cover: 1, timeline: 2, avatar: 3 }

  ### Ralations
  belongs_to :user
  belongs_to :albumable, polymorphic: true
  has_many :pictures, dependent: :destroy

  ### Callbacks
  before_create :check_date_taken

  def creator
    user
  end

  def cover_picture
    pictures.first.try(:picture)
  end


  def pictures_count
    self.pictures.count
  end

  private

    def check_date_taken
      self.date_taken ||= Date.today
    end

end
