class PicturePolicy < ApplicationPolicy

  def index?
    record.album.user == user
  end

  def show?
    record.album.user == user
  end

  def create?
    record.album.user == user
  end

  def update?
    record.album.user == user
  end

  def destroy?
    record.can_be_deleted_by user
  end

end