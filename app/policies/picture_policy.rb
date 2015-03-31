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
    record.album.user == user
  end

end