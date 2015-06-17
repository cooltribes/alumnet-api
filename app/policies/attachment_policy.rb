class AttachmentPolicy < ApplicationPolicy

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
    record.uploader == user
  end

  def destroy?
    record.uploader == user
  end

end