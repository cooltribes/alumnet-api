class Group < ActiveRecord::Base
  acts_as_tree order: "name"

  ### Validations
  validates_presence_of :name, :description, :avatar, :group_type

  ### Instance Methods

  def has_parent?
    parent.present?
  end

  def has_children?
    children.any?
  end
end
