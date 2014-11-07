class Group < ActiveRecord::Base
  acts_as_tree order: "name"
  mount_uploader :cover, CoverUploader
  enum group_type: [:open, :closed, :secret]

  ### Relations
  has_many :memberships
  has_many :users, through: :memberships
  has_many :posts, as: :postable

  ### Validations
  validates_presence_of :name, :description, :cover #:group_type

  ### Instance Methods

  def has_parent?
    parent.present?
  end

  def has_children?
    children.any?
  end

  def get_group_type_info
    { text: group_type, value: Group.group_types[group_type] }
  end

  def creator
    creator_user_id.present? ? User.find_by(id: creator_user_id) : nil
  end

  def membership_of_user(user)
    memberships.find_by(user_id: user.id)
  end
end