class Folder < ActiveRecord::Base
  ### Relations
  belongs_to :folderable, polymorphic: true
  belongs_to :creator, class_name: "User"
  has_many :attachments

  ### Validations
  validates_presence_of :name
end
