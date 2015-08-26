class UserTagging < ActiveRecord::Base
  ### Relations
  belongs_to :user
  belongs_to :tagger, class_name: 'User'
  belongs_to :taggable, polymorphic: true
end
