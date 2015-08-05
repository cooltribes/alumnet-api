class Link < ActiveRecord::Base
  ### Relations
  belongs_to :linkable, polymorphic: true

  ### Validations
  validates_presence_of :title, :description, :url
end
