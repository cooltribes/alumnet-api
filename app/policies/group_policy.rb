class GroupPolicy < ApplicationPolicy

  def index?
    true
  end

  def members?
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
    true
  end

  def destroy?
    true
  end

  def join?
    true
  end

end