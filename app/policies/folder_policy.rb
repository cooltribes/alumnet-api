class FolderPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    if record.folderable_type == "Group"
      record.folderable.user_can_upload_file(user)
    else
      true
    end
  end

  def update?
    record.creator == user
  end

  def destroy?
    record.creator == user
  end

end