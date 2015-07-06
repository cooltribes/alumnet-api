class AttachmentPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    if record.folder.folderable_type == "Group"
      record.folder.folderable.user_can_upload_files?(user)
    elsif record.folder.folderable_type == "Event"
      record.folder.folderable.user_can_upload_files?(user)
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