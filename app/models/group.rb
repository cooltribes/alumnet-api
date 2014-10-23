class Group < ActiveRecord::Base
  acts_as_tree order: "name"
  mount_uploader :avatar, AvatarUploader
  enum group_type: [:open, :closed, :secret]

  ### Relations
  has_many :memberships
  has_many :users, through: :memberships

  ### Validations
  validates_presence_of :name, :description, :avatar #:group_type

  ### Instance Methods

  def has_parent?
    parent.present?
  end

  def has_children?
    children.any?
  end

  def creator
    creator_user_id.present? ? User.find_by(id: creator_user_id) : nil
  end

  def membership_of_user(user)
    memberships.find_by(user_id: user.id)
  end
end
