class FolderPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    if record.folderable_type == "Group"
      record.folderable.user_can_upload_file?(user)
    elsif record.folderable_type == "Event"
      record.folderable.is_admin?(user)
    else
      false
    end
  end

  def update?
    record.creator == user
  end

  def destroy?
    record.creator == user
  end

end