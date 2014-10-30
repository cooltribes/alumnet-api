class Post < ActiveRecord::Base

  ### Relations
  belongs_to :user
  belongs_to :postable, polymorphic: true

  ### Validations
  validates_presence_of :body, :user_id

end
