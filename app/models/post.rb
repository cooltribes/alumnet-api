class Post < ActiveRecord::Base
  acts_as_commentable

  ### Relations
  belongs_to :user
  belongs_to :postable, polymorphic: true

  ### Validations
  validates_presence_of :body, :user_id

end
