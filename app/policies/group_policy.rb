class GroupPolicy < ApplicationPolicy

  def index?
    true
  end

  def subgroups?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def add_group?
    true
  end

  def update?
    record.user_is_admin?(user) || user.is_admin?
  end

  def destroy?
    record.user_is_admin?(user) || user.is_admin?
  end
end