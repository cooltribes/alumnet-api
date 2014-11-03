class Post < ActiveRecord::Base
  acts_as_commentable

  ### Relations
  belongs_to :user
  belongs_to :postable, polymorphic: true
  has_many :likes, as: :likeable

  ### Validations
  validates_presence_of :body, :user_id

end
