class FolderPolicy < ApplicationPolicy

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
    record.creator == user
  end

  def destroy?
    record.creator == user
  end

end