class EventPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    record.is_admin?(user)
  end

  def destroy?
    record.is_admin?(user)
  end

end