class FolderPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    if record.folderable_type == "Group"
      record.folderable.user_can_upload_files?(user)
    elsif record.folderable_type == "Event"
      record.folderable.user_can_upload_files?(user)
    else
      false
    end
  end

  def update?    
    record.user_can_edit (user)
  end

  def destroy?    
    record.user_can_edit (user)    
  end

end