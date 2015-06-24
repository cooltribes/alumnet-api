class Folder < ActiveRecord::Base
  ### Relations
  belongs_to :folderable, polymorphic: true
  belongs_to :creator, class_name: "User"
  has_many :attachments, dependent: :destroy

  ### Validations
  validates_presence_of :name

  def files_count
    self.attachments.count
  end
end
